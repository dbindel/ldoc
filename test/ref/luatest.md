% General utilities

# Table utilities

The map, transform, call, any, and all routines provide some basic
table processing methods that are missing from Lua 5.  Each of these
functions takes a function of one argument that is applied to each
table element in turn.  A table can be supplied instead, in which case,
we do table lookup; or, if the argument is nil, the identity function
is used.

~~~~~~~~~~~~~~~~~~~~~~~~~~~{.lua}
local function make_filter(fn)
   if not fn then
      return function(v) return v end
   elseif type(fn) == "table" and not fn.__call then
      return function(v) return fn[v] end
   else
      return fn
   end
end

function table.map(tbl, fn)
   local result = {}
   fn = make_filter(fn)
   for i,t in ipairs(tbl) do
      result[i] = fn(t)
   end
   return result
end

function table.transform(tbl, fn)
   fn = make_filter(fn)
   for i,t in ipairs(tbl) do
      tbl[i] = fn(t)
   end
   return tbl
end

function table.call(tbl, fn)
   for i,t in ipairs(tbl) do 
      fn(t) 
   end
end   

function table.any(tbl, fn)
   local result = nil
   fn = make_filter(fn)
   for i,t in ipairs(tbl) do
      result = result or fn(t)
   end
   return result
end

function table.all(tbl, fn)
   local result = true
   fn = make_filter(fn)
   for i,t in ipairs(tbl) do
      result = result and fn(t)
   end
   return result
end

~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Metatable-based classes

Lua tables can have attached metatables that are responsible for fallback
metamethod lookups.  Chaining together metatables is a common way of 
implementing object-oriented programming in Lua.  We define a `new_base`
method for things that we mean to treat as base classes for inheritance,
and `new` for new instances when we do not mean to inherit.

~~~~~~~~~~~~~~~~~~~~~~~~~~~{.lua}
Class = {}

function Class.new_base(tbl, parent)
   tbl = tbl or {}
   tbl.__index = tbl
   if parent then setmetatable(tbl, parent) end
   return tbl
end

function Class.new(parent, tbl)
   tbl = tbl or {}
   setmetatable(tbl, parent)
   return tbl
end

function Class.is(tbl, class)
   return tbl and (getmetatable(tbl) == class or 
                   Class.is(getmetatable(tbl), class))
end
~~~~~~~~~~~~~~~~~~~~~~~~~~~


