import { request } from '../utils/request.js';

function reqCAVIAR(data) {
    return request({
        url: '/api/v1/finemapping/caviar',
        method: 'post',
        data: JSON.stringify(data),
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    })
}

function reqPaintor(data) {
    return request({
        url: '/api/v1/finemapping/paintor',
        method: 'post',
        data: JSON.stringify(data),
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    })
}

function reqFINEMAP(data) {
    return request({
        url: '/api/v1/finemapping/finemap',
        method: 'post',
        data: JSON.stringify(data),
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    })
}

function reqCAVIARBF(data) {
    return request({
        url: '/api/v1/finemapping/caviarbf',
        method: 'post',
        data: JSON.stringify(data),
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    })
}

export default {
    reqCAVIAR,
    reqPaintor,
    reqFINEMAP,
    reqCAVIARBF
}