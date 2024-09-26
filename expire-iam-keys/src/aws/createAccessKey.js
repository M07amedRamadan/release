const { iam, secretsManager } = require('./services');
const { DRY_RUN } = require('../config');  //local running

const createAccessKey = async (user) => {
    const resp = await iam
        .createAccessKey({
            UserName: user.UserName,
        })
        .promise();
    const promises = [resp];
    try { // Update the cuurent user secret value in the secrets manager if found
    
        const oldSecretValue = await secretsManager.getSecretValue({ SecretId: `${user.UserName}` }).promise();
        const secretValue = JSON.stringify({ 
            ...oldSecretValue.SecretString,
            accessKeyId: resp.AccessKey.AccessKeyId,
            secretAccessKey: resp.AccessKey.SecretAccessKey
        });
        const updateSecretsManager = await secretsManager
        .updateSecret({
            SecretId: `${user.UserName}`,
            SecretString: secretValue,
        })
        .promise();
        //promises.push(updateSecretsManager);
        /*note we stopped the push for pushing to the secret manager as the current code overwrite the whole secret manager with corrupted data
        in case this will be needed in the future please rewrite the code and test it with a DevOps on a secret manager.
        under no curcumstances this code is allowed to be used as it's and currently this function is commented out in index.js file and the push method on line 25 is
        also commented out  */ 
    } catch (err) { // if not found then do nothing
        if (err.code === 'ResourceNotFoundException') {
            console.log("Current user doesn't have a secret to be updated.");
        }
    }
    
    if (DRY_RUN) return Promise.all(promises);
    return promises;
};

module.exports = createAccessKey;
