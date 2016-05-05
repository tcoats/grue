module.exports = (limit) ->
  size = 0
  cache = {}
  head = null
  tail = null

  shift = ->
    entry = head
    if entry
      if head.newer
        head = head.newer
        head.older = undefined
      else
        head = undefined
      entry.newer = entry.older = undefined
      delete cache[entry.key]
    entry

  size: size
  cache: cache

  get: (key) ->
    entry = cache[key]
    return null if !entry?
    return entry.value if entry is tail
    if entry.newer
      head = entry.newer if entry is head
      entry.newer.older = entry.older
    entry.older.newer = entry.newer if entry.older
    entry.newer = undefined
    entry.older = tail
    tail.newer = entry if tail
    tail = entry
    entry.value

  set: (key, value) ->
    entry =
      key: key
      value: value
    cache[key] = entry
    if tail
      tail.newer = entry
      entry.older = tail
    else
      head = entry
    tail = entry
    if size is limit
      return shift()
    else
      size++