export const func = {
    // 让el-button点击后失去焦点
    clickHandler: (evt) => {
        let target = evt.target;
        if (target.nodeName == "SPAN") {
            target = evt.target.parentNode;
        }
        target.blur();
    }
}