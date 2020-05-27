'use strict';

/**
 * This lambda rewrites an origin request for JPG or PNG to WebP assets
 * Lambda Type: Origin Request
 * Headers required: user-agent
 */

const DEBUGGING = false;

function isImageAsset(filename) {
    if (filename == null) {
        return false;
    }

    let pattern = /(jpg|png)$/i;
    return filename.match(pattern) != null;
}

function log(str) {
    if (DEBUGGING) {
        console.log(str);
    }
}

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

    log(`Request uri is rewritten to "${request.uri}"`);
    callback(null, request);
};