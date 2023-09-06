const { secretsManager } = require('./services');

const checkSecretExistence = async (user) => {
    try {
        const secretValue = await secretsManager.getSecretValue({ SecretId: `${user.UserName}` }).promise();
        return true;
    } catch (err) {
        if (err.code === 'ResourceNotFoundException') {
            return false;
        }
        //throw err;
    }
    return false;
}

module.exports = checkSecretExistence;