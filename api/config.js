require('dotenv').config({ path: __dirname + '/./.env' });
const AWSSecretManager = require('./service/awsSecretManager');
const awsSecretManagerInstance = new AWSSecretManager();

const licenseConfig = require("./license/licenseConfig");
const frontEndUrl_Local = "http://localhost:4200";
const frontEndUrl_Trial = "https://awsportal.vultara.com";
const frontEndUrl_Prod_Consulting = "https://consulting.vultara.com";
const frontEndUrl_Prod_Nikola = "https://nikolamotor.vultara.com";
const frontEndUrl_FAKECUSTOMER = "https://fakecustomer.vultara.com";
const frontEndUrls_Prod_All = [frontEndUrl_Prod_Consulting, frontEndUrl_Prod_Nikola,frontEndUrl_FAKECUSTOMER];
const sageMakerEndPointName_Trial = "";
const feasabilitySageMakerEndPoint = "trial-feasibility-model-ep";
let ssoClientId = ""; //AppId from the azure ad application registration
let tenantId = ""; //tenantId from the azure ad application registration
const microsoftPublicKey = "https://login.microsoftonline.com/common/discovery/keys"; //Microsoft's public key for verify jwt idTokens issued by them
let jiraEmail = ""; //JIRA Email of the user that created the api key
let jiraApiKey = ""; //Api key created in JIRA to send API requests to JIRA
let jiraDomain = ""; // Domain name of your JIRA e.g in our case its vultara
let jiraProjectId = ""; // Project id of your project in JIRA
let exportJira = ""; // boolean indicating if export JIRA is enabled or not
let jwtSecretKey = ""; // Secret key used to sign JWT tokens

let frontEndUrl = frontEndUrl_Local; // Local deployment
let allFrontEndUrls = [frontEndUrl_Local, frontEndUrl_Trial, ...frontEndUrls_Prod_All];
let sageMakerEndPointName = sageMakerEndPointName_Trial;
let feasabilitySageMakerEndPointName=""; // feasbility SageMake to each deployment ;
let awsSecretManagerName = "";
let secretAccessKey = null, accessKeyId = null;
// network settings for serverless deployment
let lambdaExecSecurityGroups = "";
let subnet1 = "";
let subnet2 = "";
let s3ImportBucketName = "trial-import-bucket";
var licenseFile = licenseConfig.dummyLicense;

const trial_Secret_Manager_ID = "arn:aws:secretsmanager:us-east-1:837491041518:secret:trial-application-user-deZwwl";
const consulting_Secret_Manager_ID = "arn:aws:secretsmanager:us-east-1:837491041518:secret:prod-consulting-application-user-Cy2AWB";
const nikola_Secret_Manager_ID = "arn:aws:secretsmanager:us-east-1:837491041518:secret:nikolamotor-secret-user-s4WzkI";
const fakeCustomer_Secret_Manager_ID = "arn:aws:secretsmanager:us-east-1:837491041518:secret:fakecustomer-user-eniXsa";

const APP_SERVER_LOCAL_ROOT_HTTP_URL = "http://localhost:4201/api/";
const APP_SERVER_TRIAL_ROOT_HTTP_URL = "https://awsportal.api.vultara.com/api/";
const APP_SERVER_PRODCONSULT_ROOT_HTTP_URL = "https://consulting.api.vultara.com/api/";
const APP_SERVER_PRODNIKOLA_ROOT_HTTP_URL = "https://nikolamotor.api.vultara.com/api/";
const APP_SERVER_FAKECUSTOMER_ROOT_HTTP_URL = "https://xcaf8pp6a4.execute-api.us-west-1.amazonaws.com/fakeCustomer/api/";

// URLs for nodejs server to access the report generator server, which sits in the same VPC as trial but not prod
const REPORT_SERVER_LOCAL_HTTP_URL = "http://localhost:4202/api/reports/";
const REPORT_SERVER_PROD_HTTP_URL = "http://ip-10-0-3-16.ec2.internal:4202/api/reports/";
const REPORT_SERVER_NIKOLAMOTOR_HTTP_URL = "http://ip-10-1-0-166.ec2.internal:4202/api/reports/";
const REPORT_SERVER_FAKECUSTOMER_HTTP_URL = "";

// default setups are for local hosts
let APPServerRootHTTPURL = APP_SERVER_LOCAL_ROOT_HTTP_URL;
let ReportServerHTTPURL = REPORT_SERVER_LOCAL_HTTP_URL;
const dbNameLocal = "MongoDB Atlas FreeClusterForTrial-libraries";
const dbNameTrial = "MongoDB Atlas VultaraDB Cluster0-librariesCustomer";
const dbNameProdConsulting = "MongoDB Atlas CONSULTING-PROD Cluster0-librariesCustomer";
const dbNameProdNikola = "MongoDB Atlas NIKOLA-PROD Cluster0-librariesCustomer";
const dbNameFakeCustomer = "MongoDB Atlas testingDB Cluster0-librariesCustomer";
var atlasDb, algoDb, userAccessDb, dataAnalyticsDb, componentDb, helpDb, customerDiagnosticDb;
var dbName = dbNameLocal;
var dbNameAlgo = "MongoDB Atlas VultaraDB Cluster0-algorithmDb";
var dbNameDataAnalytics = "MongoDB Atlas VultaraDB Cluster0-dataAnalyticsDb";
var dbNameComponent = "MongoDB Atlas VultaraDB Cluster0-componentDb";

// Deployment: Additional API Suffix for trial and prod
let DEPLOYMENT_API_SUFFIX = '';
let s3ReportsBucketName = 'vultara-reports-bucket'
switch (process.env.AWS_DEPLOY) {
  case "trial":
    // License information
    licenseFile = licenseConfig.trialLicense;
    // URL information
    frontEndUrl = frontEndUrl_Trial; // AWS trial deployment
    APPServerRootHTTPURL = APP_SERVER_TRIAL_ROOT_HTTP_URL;
    ReportServerHTTPURL = REPORT_SERVER_PROD_HTTP_URL;
    DEPLOYMENT_API_SUFFIX = "/trial";
    feasabilitySageMakerEndPointName = feasabilitySageMakerEndPoint;
    // Secret Manager information
    awsSecretManagerName = "vultara_trial_dotenv";
    if (!secretAccessKey || !accessKeyId) { // Do not call AWS secret manager if the access is already there.
      awsSecretManagerInstance.getAWSSecretValues(trial_Secret_Manager_ID).then((result) => {
        if (result) {
          // AWS credentials
          secretAccessKey = result.secretAccessKey;
          accessKeyId = result.accessKeyId;
        }
      });
    }
    // Database information
    atlasDb = process.env.ATLASDB; // AWS trial deployment
    dbName = dbNameTrial;
    algoDb = process.env.ATLASDB_ALGOREAD; // trial server uses Dev algorithm database, configured in AWS secret manager
    userAccessDb = process.env.ATLASDB_USERACCESS; // trial server uses Dev user database
    dataAnalyticsDb = process.env.ATLASDB_DATAANALYTICS;
    componentDb = process.env.ATLASDB_COMPONENTREAD;
    helpDb = process.env.ATLASDB_HELPREAD;
    customerDiagnosticDb = process.env.ATLASDB_CUSTOMERDIAGNOSTIC;
    ssoClientId = "352739bb-ab32-4b98-a1df-c83b1d239528"; //AppId from the azure ad application registration
    tenantId = "7080e14e-bc2f-4e33-8f20-94b691a70be5"; //tenantId from the azure ad application registration
    // network settings for serverless deployment
    lambdaExecSecurityGroups = "sg-00ca322a1f1527b43";
    subnet1 = "subnet-06ac6c1a9912bc4c4";
    subnet2 = "subnet-085ab1ee08e02e715";
    jiraEmail = "abdulrahman.riaz@vultara.com";
    jiraApiKey = "VmSRoslO14Ov1SKVClXKED49";
    jiraDomain = "vultara";
    jiraProjectId = 10007;
    exportJira = true;
    // JWT secret key
    jwtSecretKey = process.env.JWT_SECRET_KEY;

    break;
    case "prodConsulting":
      // License information
      licenseFile = licenseConfig.consultingLicense;
      // SageMaker API information
      sageMakerEndPointName = "";
      // URL information
      frontEndUrl = frontEndUrl_Prod_Consulting; // AWS production deployment
      APPServerRootHTTPURL = APP_SERVER_PRODCONSULT_ROOT_HTTP_URL;
      ReportServerHTTPURL = REPORT_SERVER_PROD_HTTP_URL;
      DEPLOYMENT_API_SUFFIX = "/consult-prod";
      // Secret Manager information
      awsSecretManagerName = "prod-consulting-application-user";
      if (!secretAccessKey || !accessKeyId) { // Do not call AWS secret manager if the access is already there.
        awsSecretManagerInstance.getAWSSecretValues(consulting_Secret_Manager_ID).then((result) => {
          if (result) {
            // AWS credentials
            secretAccessKey = result.secretAccessKey;
            accessKeyId = result.accessKeyId;
          }
        });
      }
      // Database information
      atlasDb = process.env.ATLASDB; // AWS production deployment
      userAccessDb = process.env.ATLASDB_USERACCESS;
      dbName = dbNameProdConsulting;
      algoDb = process.env.ATLASDB_ALGOREAD; // prod server algorithm database
      dataAnalyticsDb = process.env.ATLASDB_DATAANALYTICS;
      componentDb = process.env.ATLASDB_COMPONENTREAD;
      helpDb = process.env.ATLASDB_HELPREAD;
      customerDiagnosticDb = process.env.ATLASDB_CUSTOMERDIAGNOSTIC;
      ssoClientId = "352739bb-ab32-4b98-a1df-c83b1d239528"; //AppId from the azure ad application registration
      tenantId = "7080e14e-bc2f-4e33-8f20-94b691a70be5"; //tenantId from the azure ad application registration
      // network settings for serverless deployment
      lambdaExecSecurityGroups = "sg-0f2cc14ac2694892f";
      subnet1 = "subnet-0b6c5704aeec9448c";
      subnet2 = "subnet-039aca0495c205954";
      jiraEmail = "";
      jiraApiKey = "";
      jiraDomain = "";
      jiraProjectId = "";
      exportJira = false;
      // JWT secret key
      jwtSecretKey = process.env.JWT_SECRET_KEY;

      break;

    case "prodNikola":
      // License information
      licenseFile = licenseConfig.nikolaLicense;
      // SageMaker API information
      sageMakerEndPointName = "";
      // URL information
      frontEndUrl = frontEndUrl_Prod_Nikola; // AWS production deployment
      APPServerRootHTTPURL = APP_SERVER_PRODNIKOLA_ROOT_HTTP_URL;
      ReportServerHTTPURL = REPORT_SERVER_NIKOLAMOTOR_HTTP_URL;
      DEPLOYMENT_API_SUFFIX = "/nikolamotor-prod";
      // Secret Manager information
      awsSecretManagerName = "nikolamotor-secret-user";
      if (!secretAccessKey || !accessKeyId) { // Do not call AWS secret manager if the access is already there.
        awsSecretManagerInstance.getAWSSecretValues(nikola_Secret_Manager_ID).then((result) => {
          if (result) {
            // AWS credentials
            secretAccessKey = result.secretAccessKey;
            accessKeyId = result.accessKeyId;
          }
        });
      }
      // Database information
      atlasDb = process.env.ATLASDB; // AWS production deployment
      userAccessDb = process.env.ATLASDB_USERACCESS;
      dbName = dbNameProdNikola;
      algoDb = process.env.ATLASDB_ALGOREAD; // prod server algorithm database
      dataAnalyticsDb = process.env.ATLASDB_DATAANALYTICS;
      componentDb = process.env.ATLASDB_COMPONENTREAD;
      helpDb = process.env.ATLASDB_HELPREAD;
      customerDiagnosticDb = process.env.ATLASDB_CUSTOMERDIAGNOSTIC;
      ssoClientId = "1a73f4bf-0364-49c2-92a6-c8c5b552de45"; //AppId from the azure ad application registration
      tenantId = "cd45403b-72e2-4592-a46a-4687dcacfc95"; //tenantId from the azure ad application registration
      // network settings for serverless deployment
      lambdaExecSecurityGroups = "sg-06f2f21c1889e3c55";
      subnet1 = "subnet-0e86ee4668b4098ae";
      subnet2 = "subnet-0cd7d80a67192a6ce";
      jiraEmail = "";
      jiraApiKey = "";
      jiraDomain = "";
      jiraProjectId = "";
      exportJira = false;
      // s3 bucket for nikola
      s3ReportsBucketName='nikolamotor-reports-bucket';
      s3ImportBucketName='nikolamotor-import-bucket'
      // JWT secret key
      jwtSecretKey = process.env.JWT_SECRET_KEY;
  
      break;
      case "fakeCustomer":
      // License information
      licenseFile = licenseConfig.fakeCustomerLicense;
      // SageMaker API information
      sageMakerEndPointName = "";
      // URL information
      frontEndUrl = frontEndUrl_FAKECUSTOMER; // AWS production deployment
      APPServerRootHTTPURL = APP_SERVER_FAKECUSTOMER_ROOT_HTTP_URL;
      ReportServerHTTPURL = REPORT_SERVER_FAKECUSTOMER_HTTP_URL;
      // Secret Manager information
      awsSecretManagerName = "fakecustomer-user";
      if (!secretAccessKey || !accessKeyId) { // Do not call AWS secret manager if the access is already there.
        awsSecretManagerInstance.getAWSSecretValues(fakeCustomer_Secret_Manager_ID).then((result) => {
          if (result) {
            // AWS credentials
            secretAccessKey = result.secretAccessKey;
            accessKeyId = result.accessKeyId;
          }
        });
      }
      // Database information
      atlasDb = process.env.ATLASDB; // AWS production deployment
      userAccessDb = process.env.ATLASDB_USERACCESS;
      dbName = dbNameFakeCustomer;
      algoDb = process.env.ATLASDB_ALGOREAD; // prod server algorithm database
      dataAnalyticsDb = process.env.ATLASDB_DATAANALYTICS;
      componentDb = process.env.ATLASDB_COMPONENTREAD;
      helpDb = process.env.ATLASDB_HELPREAD;
      customerDiagnosticDb = process.env.ATLASDB_CUSTOMERDIAGNOSTIC;
      ssoClientId = "352739bb-ab32-4b98-a1df-c83b1d239528"; //AppId from the azure ad application registration
      tenantId = "7080e14e-bc2f-4e33-8f20-94b691a70be5"; //tenantId from the azure ad application registration
      // network settings for serverless deployment
      lambdaExecSecurityGroups = "sg-0599a888d2d14bc62";
      subnet1 = "subnet-025fc8278be0736de";
      subnet2 = "subnet-0560a9f501012305e";
      // s3 bucket for nikola
      s3ReportsBucketName='';
      s3ImportBucketName=''
      // JWT secret key
      jwtSecretKey = process.env.JWT_SECRET_KEY;
  
      break;
  case "local":
    // License information
    licenseFile = licenseConfig.localHostLicense;
    // URL information
    frontEndUrl = frontEndUrl_Local; // Local deployment
    APPServerRootHTTPURL = APP_SERVER_LOCAL_ROOT_HTTP_URL;
    ReportServerHTTPURL = REPORT_SERVER_LOCAL_HTTP_URL;
    feasabilitySageMakerEndPointName = feasabilitySageMakerEndPoint;
    // Database information
    atlasDb = process.env.ATLASTRIALDB_LOCAL; // Local deployment
    algoDb = process.env.ATLASTRIALDB_LOCAL; // prod server algorithm database
    userAccessDb = process.env.ATLASTRIALDB_NONPRODJWTUSERACCESSDB;
    dataAnalyticsDb = process.env.ATLASTRIALDB_LOCALDATAANALYTICS;
    componentDb = process.env.ATLASTRIALDB_LOCAL;
    helpDb = process.env.ATLASTRIALDB_LOCAL;
    customerDiagnosticDb = process.env.ATLASTRIALDB_LOCAL;
    dbNameAlgo = "MongoDB Atlas FreeClusterForTrial-libraries algorithm collections";
    dbNameDataAnalytics = "MongoDB Atlas FreeClusterForTrial-libraries dataAnalytics collections";
    dbNameComponent = "MongoDB Atlas FreeClusterForTrial-libraries componentDb collections";
    // AWS credentials
    secretAccessKey = process.env.secretAccessKey;
    accessKeyId = process.env.accessKeyId;
    ssoClientId = "352739bb-ab32-4b98-a1df-c83b1d239528"; //AppId from the azure ad application registration
    tenantId = "7080e14e-bc2f-4e33-8f20-94b691a70be5"; //tenantId from the azure ad application registration
    jiraEmail = "abdulrahman.riaz@vultara.com";
    jiraApiKey = "VmSRoslO14Ov1SKVClXKED49";
    jiraDomain = "vultara";
    jiraProjectId = 10007;
    exportJira = true;
    jwtSecretKey = process.env.JWT_SECRET_KEY;

    break;

  case "onPremAptiv":
   // License information
   licenseFile = licenseConfig.aptivLicense;
   ReportServerHTTPURL = "http://report-generator:4202/api/reports/";
   // Database information
   atlasDb = process.env.ATLASTRIALDB_LOCAL; // Local deployment
   algoDb = process.env.ATLASDB_ALGOREAD; // prod server algorithm database
   userAccessDb = process.env.ATLASTRIALDB_NONPRODJWTUSERACCESSDB;
   dataAnalyticsDb = process.env.ATLASTRIALDB_LOCALDATAANALYTICS;
   componentDb = process.env.ATLASTRIALDB_COMPONENTREAD;
   helpDb = process.env.ATLASTRIALDB_HELPREAD;
   customerDiagnosticDb = process.env.ATLASDB_CUSTOMERDIAGNOSTIC;
   dbNameAlgo = "MongoDB Atlas FreeClusterForTrial-libraries algorithm collections";
   dbNameDataAnalytics = "MongoDB Atlas FreeClusterForTrial-libraries dataAnalytics collections";
   dbNameComponent = "MongoDB Atlas FreeClusterForTrial-libraries componentDb collections";
   // AWS credentials
   secretAccessKey = process.env.secretAccessKey;
   accessKeyId = process.env.accessKeyId;
   ssoClientId = ""; //AppId from the azure ad application registration
   tenantId = ""; //tenantId from the azure ad application registration
   jiraEmail = "";
   jiraApiKey = "";
   jiraDomain = "vultara";
   jiraProjectId = "";
   exportJira = false;
   jwtSecretKey = process.env.JWT_SECRET_KEY;

    break;
  default:
    licenseFile = licenseConfig.dummyLicense;
    const errorMsg = `ERROR: license file configuration error. Please make sure a proper license file is selected.`;
    console.log(errorMsg);
    throw Error(errorMsg);
}

let azureAdIssuerUrl = `https://login.microsoftonline.com/${tenantId}/v2.0`; // for SSO

module.exports.DEPLOYMENT_API_SUFFIX = DEPLOYMENT_API_SUFFIX;
module.exports.licenseFile = licenseFile;
module.exports.frontEndUrl = frontEndUrl;
module.exports.allFrontEndUrls = allFrontEndUrls;
module.exports.frontEndUrls_Prod_All = frontEndUrls_Prod_All;
module.exports.s3HelpPageBucketName = "vultara-help-page-bucket";
module.exports.s3ReportsBucketName = s3ReportsBucketName;
module.exports.secretAccessKey = secretAccessKey;
module.exports.accessKeyId = accessKeyId;
module.exports.sageMakerEndPointName = sageMakerEndPointName;
module.exports.feasabilitySageMakerEndPointName = feasabilitySageMakerEndPointName;
module.exports.awsSecretManagerName = awsSecretManagerName;
module.exports.nvdDatabaseS3 = {
  aws: {
    region: "us-east-1",
    awsBaseUrl: "https://vultara-nvdsync-data.s3.amazonaws.com",
    awsBucket: "vultara-nvdsync-data"
  }
}
module.exports.ACCESS_TOKEN = "nmpj924YjeCzue5s";
module.exports.APPServerRootHTTPURL = APPServerRootHTTPURL;
module.exports.ReportServerHTTPURL = ReportServerHTTPURL;
module.exports.atlasDb = atlasDb;
module.exports.algoDb = algoDb; module.exports.userAccessDb = userAccessDb;
module.exports.dataAnalyticsDb = dataAnalyticsDb;
module.exports.componentDb = componentDb;
module.exports.helpDb = helpDb;
module.exports.dbName = dbName;
module.exports.dbNameAlgo = dbNameAlgo;
module.exports.dbNameDataAnalytics = dbNameDataAnalytics;
module.exports.dbNameComponent = dbNameComponent;
module.exports.customerDiagnosticDb = customerDiagnosticDb;


//Azure Ad variables
module.exports.azureAdAppId = ssoClientId;
module.exports.azureAdTenantId = tenantId;
module.exports.azureAdIssuerUrl = azureAdIssuerUrl;
module.exports.microsoftPublicKey = microsoftPublicKey;

// serverless deployment variables
module.exports.lambdaExecSecurityGroups = lambdaExecSecurityGroups;
module.exports.serverlessDeploySubnet1 = subnet1;
module.exports.serverlessDeploySubnet2 = subnet2;

// Jira API variables
module.exports.jiraEmail = jiraEmail;
module.exports.exportJira = exportJira;
module.exports.jiraApiKey = jiraApiKey;
module.exports.jiraDomain = jiraDomain;
module.exports.jiraProjectId = jiraProjectId;

// JWT secret key
module.exports.jwtSecretKey = jwtSecretKey;

// s3 bucket name to upload file 
module.exports.s3ImportBucketName = s3ImportBucketName;
