unless Object.keys
  # console.warn ("Esse navegador não implementou a função Object.keys(myObj). Podem ocasionar Bugs. Discuta com a equipe qual ação deve ser tomada.")
  Object.keys = (obj)->
    prop for prop of obj when obj.hasOwnProperty prop

unless Object.values
  # Como usar:
  # Object.values({a: 1, b: "2"}) # retorna [1, "2"]
  Object.values = (obj) ->
    Object.keys(obj).map (key) ->
      obj[key]
# else
#   console.warn ("Esse navegador implementou a função Object.values(myObj), e está sobrescrevendo a que foi implementada manualmente nesse sistema. Podem ocasionar Bugs. Discuta com a equipe qual ação deve ser tomada.")

unless Object.hasKey
  # Object.hasKey({x: 1}, 'x')
  Object.hasKey = (obj, key) -> Object.keys(obj).include(key)

unless Object.compact
  # Como usar
  # Ex: 1
  #
  # a = { batman: 100, coringa: 10, robin: null }
  #
  # Object.compact(a)
  # => { batman: 100, coringa: 10 }
  #
  Object.compact = (obj)->
    # Handle the 3 simple types, and null or undefined
    return obj if (null == obj || "object" != typeof obj)

    # Handle Array and Object
    switch obj.constructor
      when Array
        copy = []
        for item in obj
          continue if isBlank item
          copy.push Object.compact(item)
      when Object
        copy = {}
        for k, v of obj
          continue if isBlank v
          copy[k] = Object.compact(v)
      else
        throw new Error("Unable to compact obj! Its type isn't supported.")

    copy

unless Object.clone
  # Como usar
  # Ex: 1
  #
  # a = { batman: 100, coringa: 10 }
  # b = Object.clone(a)
  # b.coringa = 10000
  #
  # a => { batman: 100, coringa: 10 }
  # b => { batman: 100, coringa: 10000 }
  #
  Object.clone = (obj)->
    # Handle the 3 simple types, and null or undefined
    return obj if (null == obj || "object" != typeof obj)

    # Handle Array and Object
    switch obj.constructor
      when Array
        copy = []
        copy.push Object.clone(item) for item in obj
      when Object
        copy = {}
        copy[k] = Object.clone(v) for k, v of obj
      when File
        copy = new File([obj], obj.name, { type: obj.type, lastModified: obj.lastModified, lastModifiedDate: obj.lastModifiedDate, })
      else
        if {}.toString.call(obj) == '[object Object]'
          copy = obj
        else
          throw new Error("Unable to copy obj of type (#{obj.constructor})! Its type isn't supported. obj: #{obj}")

    copy

unless Object.getKeys
  # Como usar
  # Ex: 1
  #
  # Object.getKeys({ vitima: 'working in the bank', ladrao: 'stealing bank' }, 'vitima', 'policia')
  # => [ 'vitima' ]
  #
  Object.getKeys = (obj, keyNames...)->
    list = []
    for keyName in keyNames
      list.push keyName if obj.hasOwnProperty(keyName)
      continue unless keyName.test?
      list = list.concat Object.keys(obj).select((el)-> keyName.test(el))
    list

unless Object.slice
  # Como usar
  # Ex: 1
  # Object.slice({a:1, b: 2, c: 3, d: 4}, 'a', 'd') # return {a:1, d:4}
  # Ex 2:
  # keys = ['a', 'd']
  # Object.slice({a:1, b: 2, c: 3, d: 4}, keys...) # return {a:1, d:4}
  # Ex 3: (REGEXP)
  # Object.slice({uva_thompson: 0, uva_rubi: 1, uva_crimson: 2, batata: 4}, /^uva/)  # => { uva_thompson: 0, uva_rubi: 1, uva_crimson: 2 }
  Object.slice = (obj, keyNames...)->
    selectKeys = Object.getKeys(obj, keyNames...)

    ret = {}
    ret[key] = obj[key] for key in selectKeys
    ret

unless Object.reject
  # Como usar
  # Ex: 1
  # Object.reject({a:1, b: 2, c: 3, d: 4}, 'a', 'd') # return {b:2, c:3}
  # Ex 2:
  # keys = ['a', 'd']
  # Object.reject({a:1, b: 2, c: 3, d: 4}, keys...) # return {b:2, c:3}
  # Ex 3: (REGEXP)
  # Object.reject({tomate: 0, alface: 1, jilo: 2, jilo_jaiba: 33}, /^jilo/) # => { tomate: 0, alface: 1 }
  Object.reject = (obj, keyNames...)->
    exceptKeys = Object.getKeys(obj, keyNames...)

    ret = Object.clone obj
    delete ret[key] for key in exceptKeys
    ret

unless Object.blank
  # console.warn ("Esse navegador não implementou a função Object.blank(myObj). Podem ocasionar Bugs. Discuta com a equipe qual ação deve ser tomada.")
  Object.blank = (val)->
    return false if ['number', 'boolean', 'function'].include typeof(val)
    return true unless val?
    return val.empty() if ['string'].include typeof(val)
    Object.empty(val)

unless Object.present
  # console.warn ("Esse navegador não implementou a função Object.blank(myObj). Podem ocasionar Bugs. Discuta com a equipe qual ação deve ser tomada.")
  Object.present = (val)-> !Object.blank(val)

unless Object.empty
  # console.warn ("Esse navegador não implementou a função Object.empty(myObj). Podem ocasionar Bugs. Discuta com a equipe qual ação deve ser tomada.")
  Object.empty = (obj)->
    Object.keys(obj).empty()

unless Object.any
  # console.warn ("Esse navegador não implementou a função Object.any(myObj). Podem ocasionar Bugs. Discuta com a equipe qual ação deve ser tomada.")
  Object.any = (obj)->
    Object.keys(obj).any()

unless Object.many
  # console.warn ("Esse navegador não implementou a função Object.many(myObj). Podem ocasionar Bugs. Discuta com a equipe qual ação deve ser tomada.")
  Object.many = (obj)->
    Object.keys(obj).many()

unless Object.delete
  Object.delete = (obj, key)->
    delete obj[key]
    obj

unless Object.equals
  # console.warn ("Esse navegador não implementou a função Object.equals(obj1, obj2). Podem ocasionar Bugs. Discuta com a equipe qual ação deve ser tomada.")
  Object.equals = (obj1, obj2)->
    return true if obj1 == obj2
    # if both obj1 and obj2 are null or undefined and exactly the same

    return false if ( ! ( obj1 instanceof Object ) || ! ( obj2 instanceof Object ) )
    # if they are not strictly equal, they both need to be Objects

    return false if obj1.constructor != obj2.constructor
    # they must have the exact same prototype chain, the closest we can do is
    # test there constructor.

    for obj of obj1
      continue if ( ! obj1.hasOwnProperty( obj ) )
      # other properties were tested using obj1.constructor == obj2.constructor

      return false if ( ! obj2.hasOwnProperty( obj ) )
      # allows to compare obj1[ obj ] and obj2[ obj ] when set to undefined

      continue if obj1[ obj ] == obj2[ obj ]
      # if they have the same strict value or identity then they are equal

      return false if typeof( obj1[ obj ] ) != "object"
      # Numbers, Strings, Functions, Booleans must be strictly equal

      return false if ( ! Object.equals( obj1[ obj ], obj2[ obj ] ) )
      # Objects and Arrays must be tested recursively

    for obj of obj2
      return false if ( obj2.hasOwnProperty( obj ) && ! obj1.hasOwnProperty( obj ) )
      # allows obj1[ obj ] to be set to undefined

    true

unless Object.clear
  # console.warn ("Esse navegador não implementou a função Object.equals(obj1, obj2). Podem ocasionar Bugs. Discuta com a equipe qual ação deve ser tomada.")
  Object.clear = (obj)->
    for key in Object.keys(obj)
      delete obj[key]
