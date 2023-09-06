const AWS = require('aws-sdk');
const { AWS_SES_REGION } = require('../config');

module.exports = {
    iam: new AWS.IAM(),
    secretsManager: new AWS.SecretsManager(),
    ses: new AWS.SES({ region: AWS_SES_REGION }),
};
