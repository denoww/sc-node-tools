############# HOW TO USE ###############
# require('./scErrorsHandle')
# isArray([])
############# HOW TO USE ###############

global.isFile     = (val) -> !!val && typeof val == 'object' && val.constructor == File
global.isObject   = (val) -> !!val && typeof val == 'object' && val.constructor == Object
global.isArray    = (val) -> !!val && typeof val == 'object' && val.constructor == Array
global.isNumber   = (val) -> typeof val == 'number' && isFinite(val)
global.isString   = (val) -> typeof val == 'string' || val instanceof String
global.isFunction = (val) -> typeof val == 'function'
global.isNull     = (val) -> [undefined, null].includes(val)
global.isBlank    = (val) ->
    arrayEmpty  = isArray(val) && val.empty()
    objectEmpty = isObject(val) && Object.empty(val)
    isNull(val) || [''].includes(val) || arrayEmpty || objectEmpty
global.isPresent  = (val) -> !isBlank(val)
