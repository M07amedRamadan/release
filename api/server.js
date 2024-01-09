// require("./database/localDatabaseConnect");
const express = require("express");
const fs = require('fs');
const path = require('path');
const app = express();
const projectDb = require("./database/projectDatabase").router;
const executeAlgorithmForScheduler = require('./database/executeAlgorithmForScheduler').router;
const dashboardRoutes = require("./database/routesForDashboard").router;
const threatLibDb = require("./database/threatLibDb");
const componentDb = require("./database/componentLibDb");
const featureDb = require("./database/featureLibDb");
const assetDb = require("./database/assetLibDb");
const systemConfigDb = require("./database/systemConfigDb");
const mitreAttackDb = require("./database/mitreAttackDb");
const userAccess = require("./database/userAccessDb");
const frontEndEnvParams = require("./database/frontEndEnvParams");
const milestoneSchedulerDb = require("./database/milestoneScheduleDb");
const sharedComponentDb = require("./database/sharedComponentDb");
const projectVulnerbilityDb = require("./database/vulnerbilityDb")
const projectAssumptionDb = require("./database/projectAssumptionDb")
const ptojectNotificationDb = require("./database/projectNotificationDb")
const projectReportsDb = require("./database/reports")
const riskUpdateNotificationDb = require("./database/riskUpdateNotificationDb");
const securedUserAccess = require("./database/securedUserAccessDb");
const otherNotificationsDb = require("./database/otherNotificationsDb");
const projectMilestoneDb = require("./database/projectMilestoneDb");
const projectAnalysisEvidenceDb = require("./database/projectAnalysisEvidenceDb");
const storeReportInformation = require("./database/storeReportInformation");
const helpPageDb = require("./database/helpPageDb");
const weaknessDb = require("./database/weaknessDb");
const requirementsDb = require("./database/requirementDb");
const projectTriggerDb = require("./database/projectTriggerDb");
const projectCybersecurityEventDb = require("./database/projectCybersecurityEventDb");
const projectCybersecurityInformationDb = require("./database/projectCybersecurityInformationDb");
const projectDamageScenarioPoolDb = require("./database/projectPoolDamageScenarioDb");
const projectRelationDb = require("./database/projectRelationDb");
const policyDb = require("./database/policyDb");
const attackActionLibDb = require("./database/attackActionLibDb");
const projectBomDb = require("./database/projectBomDb");
const projectInfoDb = require("./database/projectInfoDb");
const generateAttackFeasibilityRatings = require("./database/generateFeasibilityRatings");
const projectAttackTreeDb = require("./database/projectAttackTreeDb");
const uploadFile = require("./database/uploadFile");
const customFieldDb = require("./database/customFieldDb");
const taskListDb = require("./database/taskListDb");
const documentImportDb = require("./database/documentImportDb");
const backwardCompatibilityDb = require("./database/backwardCompatibilityDb");
const errorLogHandlerDb = require("./database/errorLogHandlerDb");
const passport = require('passport');
const morgan = require("morgan");
require('dotenv').config({ path: __dirname + '/./.env' });
const cryptoService = require("./service/cryptoService");
const licenseService = require("./service/licenseService");
const schedule = require('node-schedule');
const { default: mongoose } = require("mongoose");
const license = require('./config').licenseFile;

const frontEndUrl = require("./config").frontEndUrl;
const frontEndUrls_Prod_All = require("./config").frontEndUrls_Prod_All;

app.use(passport.initialize());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ limit: '50mb', extended: true }));
app.use(morgan(':remote-addr - [:date[clf]] ":method :url HTTP/:http-version" :status :res[content-length] ":referrer"'))
app.use(express.static(path.join(__dirname, 'dist/vultara')));

// CORS access control header
app.use((req, res, next) => {
  switch (process.env.AWS_DEPLOY) {
    case "prodConsulting":
    case "prodNikola":
      case "fakeCustomer":
      const allowedOrigins = [...frontEndUrls_Prod_All]; // in the future we will implement multitenant architecture for production server
      const origin = req.headers.origin;
      if (allowedOrigins.includes(origin)) {
        res.header("Access-Control-Allow-Origin", origin); // restrict it to the required domain
      }
      break;

    default:
      res.header("Access-Control-Allow-Origin", frontEndUrl);
      break;
  }
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept, Authorization"
  );
  res.header("Access-Control-Allow-Credentials", true); // for sessions
  if (req.method === "OPTIONS") {
    res.header("Access-Control-Allow-Methods", "PUT, POST, PATCH, DELETE,GET");
    return res.status(200).json({});
  };
  next();
});

// session setup for local strategy
// const sessionStore = new MongoStore({ mongooseConnection: connection, collection: 'sessions' });
// app.use(session({
//     secret: process.env.SESSION_SECRET,
//     resave: false,
//     saveUninitialized: true,
//     store: sessionStore,
//     cookie: {
//         maxAge: 1000 * 60 * 60 * 24, // 1000 msec = 1 sec, 60 secs, 60 mins, 24 hours
//         secure: false,
//     }
// }));
// require("./service/passportLocalSetup");
// app.use(passport.initialize());
// app.use(passport.session());
// app.use((req, res, next) => {
//     console.log(req.session);
//     console.log(req.user);
//     console.log("isAuthenticated: " + req.isAuthenticated());
//     // console.log(req);
//     next();
// });

// function that excludes specific paths from middleware
const ignorePath = (middleware, ...paths) => (req, res, next) => paths.some(path => path === req.path) ? next() : middleware(req, res, next);
const ignoreMethod = (middleware, ...methods) => (req, res, next) => methods.some(method => method == req.method) ? next() : middleware(req, res, next);


// route to show the server is up running
if(license.deploymentType !== "fullOnPrem") {
  app.get("/", (req, res) => {
    res.send("Server is running.");
  });
}
// Add checkTokenExpiration middleware to all routes
app.use(ignorePath(cryptoService.checkAccessTokenExpiry, "/api/envVars"));
// account-related route that doesn't require security check, such as user login
app.use("/api/user", userAccess);
// route for fetching frontEnd Env parameters
app.use("/api/envVars", frontEndEnvParams);
// routes for shared components, including protocolLib, microLib, commLineLib
app.use("/api/sharedcomponents", passport.authenticate('jwt', { session: false }), sharedComponentDb);
// route for project data and project execution
app.use("/api/projects",
  passport.authenticate('jwt', { session: false }),
  ignorePath(cryptoService.userAuth(), "/getAllProjectIdsOfUser", "/cybersecurityGoalsLibrary", "/wp29Threats", "/controlLib"), projectDb);
app.use('/api/executealgorithm', executeAlgorithmForScheduler)
// route for dashboard
app.use("/api/dashboard", passport.authenticate('jwt', { session: false }), cryptoService.userAuth(), dashboardRoutes);
// route for customer-specific component DB
app.use("/api/components", passport.authenticate('jwt', { session: false }), componentDb);
// route for feature data
app.use("/api/features", passport.authenticate('jwt', { session: false }), featureDb);
// route for asset data
app.use("/api/assets", passport.authenticate('jwt', { session: false }), assetDb);
// route for system configurations
app.use("/api/config", passport.authenticate('jwt', { session: false }), ignoreMethod(cryptoService.userAuth('Admin', 'Super Admin'), "GET"), systemConfigDb);
// route for custom fields
app.use("/api/customField", passport.authenticate('jwt', { session: false }), ignoreMethod(cryptoService.userAuth('Admin', 'Super Admin'), "GET"), customFieldDb);
// route for mitreAttack
app.use("/api/mitreattack", passport.authenticate('jwt', { session: false }), mitreAttackDb);
// route to use threat libraries. only NodeJS uses this route. No direct front end access is allowed.
app.use("/api/libraries", threatLibDb);
// scheduler route that should be executed only from backend when node-scheduler find out specified EST time (Sunday 7PM)
app.use("/api/milestone-schedule", milestoneSchedulerDb);
// route for save error log into db  For Schedule Server & Report Generator
app.use("/api/saveErrorLogIntoDb", errorLogHandlerDb);
// route for user task list
app.use("/api/taskList", passport.authenticate('jwt', { session: false }), taskListDb);
// route for vulnerability
app.use("/api/vulnerability", passport.authenticate('jwt', { session: false }), cryptoService.userAuth(), projectVulnerbilityDb);
// route for assumption
app.use("/api/assumption", passport.authenticate('jwt', { session: false }), cryptoService.userAuth(), projectAssumptionDb);
// route for reports
app.use("/api/reports", passport.authenticate('jwt', { session: false }), projectReportsDb);
// route for notifications
app.use("/api/riskUpdate", passport.authenticate('jwt', { session: false }), ignorePath(cryptoService.userAuth(), "/email"), riskUpdateNotificationDb);
// account-related route that requires security check
app.use("/api/secureduser", passport.authenticate('jwt', { session: false }), securedUserAccess);
// route for other notifications
app.use("/api/otherNotifications", passport.authenticate('jwt', { session: false }), cryptoService.userAuth(), otherNotificationsDb);
// route for project milestones
app.use("/api/milestones", passport.authenticate('jwt', { session: false }), cryptoService.userAuth(), projectMilestoneDb);
// route for project analysis evidence
app.use("/api/project-analysis-evidence", passport.authenticate('jwt', { session: false }), cryptoService.userAuth(), projectAnalysisEvidenceDb);
// route for storing report information from the EC2 server
app.use("/api/storeReports", storeReportInformation);
// route for helpPage
app.use("/api/helpPage", passport.authenticate('jwt', { session: false }), helpPageDb);
// route for weaknesses
app.use("/api/weakness", passport.authenticate('jwt', { session: false }), cryptoService.userAuth(), weaknessDb);
//route for requirements
app.use("/api/requirements", passport.authenticate('jwt', { session: false }), ignorePath(cryptoService.userAuth(), "/libRequirements"), requirementsDb);
//route for project triggers
app.use("/api/trigger", passport.authenticate('jwt', { session: false }), cryptoService.userAuth(), projectTriggerDb);
//route for project cybersecurity events
app.use("/api/cybersecurityEvent", passport.authenticate('jwt', { session: false }), cryptoService.userAuth(), projectCybersecurityEventDb);
//route for project cybersecurity information
app.use("/api/cybersecurityInformation", passport.authenticate('jwt', { session: false }), cryptoService.userAuth(), projectCybersecurityInformationDb);
//route for project poolDamageScenario
app.use("/api/poolDamageScenario", passport.authenticate('jwt', { session: false }), cryptoService.userAuth(), projectDamageScenarioPoolDb);
// route for policy database
// delete userAuth function from this route to make it like other library routes when we call userAuth for Security engineer
// no projectId provided, he can access this library without loading a project
//Any user that has no access to library can not reach to organization policy
app.use("/api/policy", passport.authenticate('jwt', { session: false }), policyDb); 
// route for project relation
app.use("/api/relation", passport.authenticate('jwt', { session: false }),cryptoService.userAuth(), projectRelationDb);
// route for project BOM
app.use("/api/bom", passport.authenticate('jwt', { session: false }), cryptoService.userAuth(), projectBomDb);
// route for generate feasability ratings 
app.use("/api/generateFeasibilityRatings" ,passport.authenticate('jwt', { session: false }), cryptoService.userAuth(), generateAttackFeasibilityRatings)
// route for project attack tree 
app.use("/api/attackTree", passport.authenticate('jwt', { session: false }),cryptoService.userAuth(), projectAttackTreeDb);
// route for project info
app.use("/api/projectInfo", passport.authenticate('jwt', { session: false }), cryptoService.userAuth(), projectInfoDb);

app.use("/api/attackAction", passport.authenticate('jwt', { session: false }), attackActionLibDb);
app.use("/api/uploadFile", passport.authenticate('jwt', { session: false }), uploadFile);
app.use("/api/documentImport", passport.authenticate('jwt', { session: false }), cryptoService.userAuth(), documentImportDb);

// route for all notifications info
app.use("/api/allNotifications", passport.authenticate('jwt', { session: false }), cryptoService.userAuth(), ptojectNotificationDb );
if(license.deploymentType === "fullOnPrem") {
  app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'dist/vultara', 'index.html'));
  });
  // Create a cron job to check if the license is expired daily at 4:00 AM UTC and clear "libraries" database if it is expired
  schedule.scheduleJob('0 4 * * *', licenseService.onPremLicenseCheck);
}

if (process.env.AWS_DEPLOY == "local" || license.deploymentType == "fullOnPrem") { // local host on port 4201
  const port = 4201;
  app.listen(port, () => {
    console.log(`Listening on port ${port}...`);
  });
} else if (process.env.AWS_DEPLOY == 'trial') { //
  var serverless = require('serverless-http');
  module.exports.handler = serverless(app);
  // const port = process.env.PORT;
  // app.listen(port, () => {
  //   console.log(`Listening on port ${port}...`);
  // });
} else if (['prodConsulting', 'prodNikola','fakeCustomer'].includes(process.env.AWS_DEPLOY)) {
  var serverless = require('serverless-http');
  module.exports.handler = serverless(app);
} else {
  console.log(`Error: Missing .env file or value of AWS_DEPLOY in .env file is invalid. Valid AWS_DEPLOY values include "local", "trial", and "prod".`);
}
// this port is running, but not tested
//https.createServer(options, app).listen(8080);
