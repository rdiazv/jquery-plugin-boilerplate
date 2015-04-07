
# $('elem').myPlugin optionA: 'myNewValue'
# $('elem').myPlugin 'customMethod', 'test'
# $('elem').myPlugin 'destroy'

do ($ = window.jQuery) ->

  class MyPlugin
    defaults:
      optionA: 'myValue'

    constructor: (el, options) ->
      @options = $.extend {}, @defaults, options
      @$el = $(el)
      @$el.on 'click.myPlugin', @onClick
      @build()

    build: ->
      @$markup = $('<div>Initialized</div>').insertAfter(@$el)

    onClick: (event) =>
      @customMethod 'clicked!'

    customMethod: (text) ->
      console.log 'customMethod', text, @options.optionA

    destroy: ->
      @$markup.off().remove()
      @$el.off('.myPlugin').removeData('myPlugin')

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
