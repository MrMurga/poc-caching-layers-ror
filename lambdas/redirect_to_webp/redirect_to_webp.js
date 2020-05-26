'use strict';

function isImageAsset(filename) {
    if (filename == null) {
        return false;
    }

    let pattern = /(jpg|png)$/i;
    return filename.match(pattern) != null;
}

// origin request based user-agent
exports.handler = async (event, context, callback) => {
    const request = event.Records[0].cf.request;
    const headers = request.headers;
    let isChrome = false;

    if (request && request.uri && isImageAsset(request.uri) && headers['user-agent']) {
        const agent = headers['user-agent'][0].value;
        isChrome = (agent.indexOf('Chrome/') != -1)

        if (isChrome) {
            request.uri += '.webp';
        }
    }

    console.log(`Request uri is "${request.uri}"`);
    callback(null, request);
};