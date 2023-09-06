const { secretsManager } = require('./services');

const checkSecretExistence = async (user) => {
    try {
        const secretValue = await secretsManager.getSecretValue({ SecretId: `${user.UserName}` }).promise();
        console.log(secretValue,'for the user ', user.UserName);
        return true;
    } catch (err) {
        // console.log('exist', err);
        if (err.code === 'ResourceNotFoundException') {
            console.log('this the first step to be expired at 3 months')
            return false;
        }
        //throw err;
    }
    return false;
}

module.exports = checkSecretExistence;