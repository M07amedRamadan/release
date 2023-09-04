const deleteAccessKey = require('./aws/deleteAccessKey');
const createAccessKey = require('./aws/createAccessKey');
const getUsersAndKeys = require('./aws/getUsersAndKeys');
const expired = require('./utils/expired');
const shouldRemove = require('./utils/shouldRemove');
const daysTilExpiry = require('./utils/daysTilExpiry');
const expiredInLastDay = require('./utils/expiredInLastDay');
const notifyUser = require('./notifications/notifyUser');
const warnUser = require('./notifications/warnUser');
const checkSecretExistence = require('./aws/checkSecretExistence');
const { ONE_MONTH, ONE_DAY, ONE_WEEK } = require('./constants');
const {
    DRY_RUN,
    USERNAME_REGEX,
    KEY_MAX_AGE_SECS,
    LAST_WARNING_MAX_AGE_SECS,
    SECOND_WARNING_MAX_AGE_SECS,
    FIRST_WARNING_MAX_AGE_SECS,
} = require('./config');

const processUser = async ([user, accessKeys]) => {
    console.log(`\nChecking user ${user.UserName}`);

    if (!accessKeys.length) {
        console.log('No access keys found');
        return;
    }

    // if the current user have a secret in the secrets manager then make the default expiry date 1 year
    let USER_KEY_MAX_AGE_SECS = KEY_MAX_AGE_SECS,
        USER_FIRST_WARNING_MAX_AGE_SECS = FIRST_WARNING_MAX_AGE_SECS,
        USER_SECOND_WARNING_MAX_AGE_SECS = SECOND_WARNING_MAX_AGE_SECS,
        USER_LAST_WARNING_MAX_AGE_SECS = LAST_WARNING_MAX_AGE_SECS;

    // if not, make the expiry date 3 months
    const flag = await checkSecretExistence(user);
    console.log("================",flag, user.UserName);
    if (flag == false ) {
        console.log("this hasn't a secret secont step",user.UserName);
        USER_KEY_MAX_AGE_SECS = 3 * ONE_MONTH;
        USER_FIRST_WARNING_MAX_AGE_SECS = USER_KEY_MAX_AGE_SECS - 2 * ONE_WEEK;
        USER_SECOND_WARNING_MAX_AGE_SECS = USER_KEY_MAX_AGE_SECS - ONE_WEEK;
        USER_LAST_WARNING_MAX_AGE_SECS = USER_KEY_MAX_AGE_SECS - ONE_DAY;
    }
    else {
        console.log(USER_KEY_MAX_AGE_SECS,'this the time to e')
    }

    return Promise.all(
        accessKeys.map(key => {
            if (expired(key.CreateDate, USER_KEY_MAX_AGE_SECS)) {
                if (shouldRemove(key.CreateDate, USER_KEY_MAX_AGE_SECS)) {
                    console.log(`Removing expired access key ${key.AccessKeyId}`);

                    return Promise.all([
                        deleteAccessKey(user, key),
                        notifyUser(user, key),
                        createAccessKey(user),
                    ]);
                }

                console.log(
                    `The access key ${key.AccessKeyId} is expired but was not removed`
                );
                return;
            }

            console.log(
                `Access key ${key.AccessKeyId} will expire in ` +
                    `${daysTilExpiry(key.CreateDate, USER_KEY_MAX_AGE_SECS)} days`
            );

            if (expiredInLastDay(key.CreateDate, USER_LAST_WARNING_MAX_AGE_SECS)) {
                console.log(`Sending last warning`);
                return warnUser(user, key, '24 hours');
            }

            if (expiredInLastDay(key.CreateDate, USER_SECOND_WARNING_MAX_AGE_SECS)) {
                console.log(`Sending second warning`);
                return warnUser(user, key, '1 week');
            }

            if (expiredInLastDay(key.CreateDate, USER_FIRST_WARNING_MAX_AGE_SECS)) {
                console.log(`Sending first warning`);
                return warnUser(user, key, '2 weeks');
            }

            console.log('No action taken.');
            return undefined;
        })
    );
};

exports.handler = async () => {
    console.log('=== Starting IAM user access key scan ===');

    if (DRY_RUN)
        console.log(
            '*** Dry run enabled. No notifications will be sent or access keys deleted ***\n'
        );

    const usersAndKeys = await getUsersAndKeys();

    console.log(`Found ${usersAndKeys.length} users.`);

    // Filter out any usernames not matched by the filter
    const filteredUsersAndKeys = usersAndKeys.filter(([user]) =>
        USERNAME_REGEX.test(user.UserName)
    );

    console.log(
        `Found ${filteredUsersAndKeys.length} users after filtering by RegEx: `,
        USERNAME_REGEX
    );

    await Promise.all(filteredUsersAndKeys.map(processUser));

    console.log('=== Done ===');
};
