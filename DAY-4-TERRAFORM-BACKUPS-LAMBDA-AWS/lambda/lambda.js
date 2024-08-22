const AWS = require('aws-sdk');
const sns = new AWS.SNS();

exports.handler = async (event) => {
  const backupState = event.detail.state;
  const backupArn = event.detail.backupVaultArn;
  const message = `Backup ${backupState}: ${backupArn}`;

  await sns.publish({
    Message: message,
    TopicArn: process.env.SNS_TOPIC_ARN
  }).promise();

  return { statusCode: 200, body: 'Notification sent.' };
};
