import { request } from '../utils/request.js';

function reqFinemap(data) {
    return request({
        url: '/api/v1/chart/finemap',
        method: 'get',
        params: {
            jobId: data
        },
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    })
}

function reqPaintor(data) {
    return request({
        url: '/api/v1/chart/paintor',
        method: 'get',
        params: {
            jobId: data
        },
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    })
}

function reqCaviarbf(data) {
    return request({
        url: '/api/v1/chart/caviarbf',
        method: 'get',
        params: {
            jobId: data
        },
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    })
}

function reqCaviar(data) {
    return request({
        url: '/api/v1/chart/caviar',
        method: 'get',
        params: {
            jobId: data
        },
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    })
}

function reqColoc(data) {
    return request({
        url: '/api/v1/chart/coloc',
        method: 'get',
        params: {
            jobId: data
        },
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    })
}

function reqEcaviar(data) {
    return request({
        url: '/api/v1/chart/ecaviar',
        method: 'get',
        params: {
            jobId: data
        },
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    })
}

function reqFastenloc(data) {
    return request({
        url: '/api/v1/chart/fastenloc',
        method: 'get',
        params: {
            jobId: data
        },
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    })
}

function reqSpredixcan(data) {
    return request({
        url: '/api/v1/chart/s-predixcan',
        method: 'get',
        params: {
            jobId: data
        },
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    })
}

function reqFusion(data) {
    return request({
        url: '/api/v1/chart/fusion',
        method: 'get',
        params: {
            jobId: data
        },
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    })
}

export default {
    reqFinemap,
    reqPaintor,
    reqCaviarbf,
    reqCaviar,
    reqColoc,
    reqEcaviar,
    reqFastenloc,
    reqSpredixcan,
    reqFusion,
}