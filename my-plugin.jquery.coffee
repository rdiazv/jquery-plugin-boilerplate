
# $('elem').myPlugin optionA: 'myNewValue'
# $('elem').myPlugin 'customMethod', 'test'
#
do ($ = window.jQuery) ->

  class MyPlugin
    defaults:
      optionA: 'myValue'

    constructor: (el, options) ->
      @options = $.extend {}, @defaults, options
      @$el = $(el)

    customMethod: (text) ->
      console.log 'customMethod', text, @options.optionA

  $.fn.extend myPlugin: (method, args...) ->
    @each ->
      data = $(this).data 'myPlugin'

      unless data?
        data = new MyPlugin this, method
        $(this).data myPlugin: data

      return unless _.isString method

      if _.isFunction data[method]
        data[method].apply data, args

      else
        $.error 'The method #{method} don\'t exists on myPlugin'
