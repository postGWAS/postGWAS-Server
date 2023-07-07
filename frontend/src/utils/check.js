// 判断ref文件数组是否为空
const isFilesNull = (files) => {
    return files.value.length === 0;
}

// 判断ref输入数据是否合法
const isInputIllegal = (input) => {
    return input.value == null || input.value == "";
}

const isNumber = (num) => {
    if (typeof num === 'undefined') {
        return false;
    } else {
        if(num === "") return false;
        if (isNaN(num)) {
            return false;
        } else {
            return true;
        }
    }
}

export default {
    isFilesNull,
    isInputIllegal,
    isNumber
}