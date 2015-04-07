
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
      instance = $(this).data 'myPlugin'

      if not instance?
        if (not method? or $.isPlainObject(method))
          instance = new MyPlugin this, method
          $(this).data myPlugin: instance

        else if method != 'destroy'
          $.error 'myPlugin has not been initialized in this element'

      else if typeof method == 'string'
        if $.isFunction(instance[method])
          instance[method].apply instance, args

        else
          $.error "Method #{method} does not exists on myPlugin"
