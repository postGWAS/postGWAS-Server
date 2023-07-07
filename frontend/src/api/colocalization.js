import { request } from '../utils/request.js';

function reqColoc(data) {
    return request({
        url: '/api/v1/colocalization/coloc',
        method: 'post',
        data: JSON.stringify(data),
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    })
}

function reqFastENCOL(data) {
    return request({
        url: '/api/v1/colocalization/fastenloc',
        method: 'post',
        data: JSON.stringify(data),
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    })
}

function reqECAVIAR(data) {

    return request({
        url: '/api/v1/colocalization/ecaviar',
        method: 'post',
        data: JSON.stringify(data),
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    })
}

export default {
    reqColoc,
    reqFastENCOL,
    reqECAVIAR

}