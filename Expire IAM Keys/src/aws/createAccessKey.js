const { iam, secretsManager } = require('./services');
const { DRY_RUN } = require('../config');  //local running

const createAccessKey = async (user) => {
    console.log("Creating A New Access Key")
    const resp = await iam
        .createAccessKey({
            UserName: user.UserName,
        })
        .promise();
    const promises = [resp];
    console.log('this befor the try');
    try { // Update the cuurent user secret value in the secrets manager if found
        const secretValue = JSON.stringify({ 
            accessKeyId: resp.AccessKey.AccessKeyId,
            secretAccessKey: resp.AccessKey.SecretAccessKey
        });
        console.log('current updating username',user.UserName);
        const updateSecretsManager = await secretsManager
        .updateSecret({
            SecretId: `${user.UserName}`,
            SecretString: secretValue,
        })
        .promise();
                console.log(updateSecretsManager,'update sucessfully for', user.UserName);
        promises.push(updateSecretsManager);
    } catch (err) { // if not found then do nothing
    //console.log('update err',err);
        if (err.code === 'ResourceNotFoundException') {
            console.log("Current user doesn't have a secret to be updated.");
        }
    }
    
    if (DRY_RUN) return Promise.all(promises);
    return promises;
};

module.exports = createAccessKey;
