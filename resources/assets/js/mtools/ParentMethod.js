//--------------------------------------------
var ParentMethod = function(th, methodName, LastFirst, componentTag) {
    let parent = th.$parent,
        root = th.$root,
        obj = null;
    while(parent) {
        let options = parent.$options, m;
        if(typeof options.methods !== 'undefined') {
            m = options.methods[methodName];
            if(typeof m !== 'undefined') {
                obj = {};
                obj.th = parent;
                obj.method = m;
                if(typeof LastFirst !== 'undefined' && LastFirst > 0) {
                    if(!--LastFirst) break;
                }
                if(typeof componentName !== 'undefined' && options._componentTag === componentTag) break;
            }
        }
        if(parent == root) break;
        parent = parent.$parent;
    }
    return obj;
}

module.exports = ParentMethod;
