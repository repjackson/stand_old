
Template.registerHelper 'in_role', (role)->
    if Meteor.user() and Meteor.user().roles
        if role in Meteor.user().roles
            true
        else
            false
    else
        false
Template.registerHelper 'field_value', () ->
    # console.log @
    parent = Template.parentData()
    parent5 = Template.parentData(5)
    parent6 = Template.parentData(6)


    if @direct
        parent = Template.parentData()
    else if parent5
        if parent5._id
            parent = Template.parentData(5)
    else if parent6
        if parent6._id
            parent = Template.parentData(6)
    # console.log 'parent', parent
    if parent
        parent["#{@key}"]

Template.registerHelper 'is_admin', () ->
    # Meteor.users.findOne username:Router.current().params.username
    if Meteor.user() and Meteor.user().roles
        if 'admin' in Meteor.user().roles then true else false


Template.registerHelper 'is_author', () ->
    # if @_author_id and Meteor.userId()
    @_author_id is Meteor.userId()


Template.registerHelper 'can_edit', () ->
    # if @_author_id and Meteor.userId()
    @_author_id is Meteor.userId()
    if Meteor.user().roles
        'admin' in Meteor.user().roles



Template.registerHelper 'current_doc', () -> Docs.findOne Router.current().params.doc_id

Template.registerHelper 'lowered_title', ()-> @title.toLowerCase()

Template.registerHelper 'lowered', (input)-> input.toLowerCase()

Template.registerHelper 'session_key_value_is', (key, value) ->
    # console.log 'key', key
    # console.log 'value', value
    Session.equals key,value

Template.registerHelper 'key_value_is', (key, value) ->
    # console.log 'key', key
    # console.log 'value', value
    @["#{key}"] is value


Template.registerHelper 'template_subs_ready', () ->
    Template.instance().subscriptionsReady()

Template.registerHelper 'global_subs_ready', () ->
    Session.get('global_subs_ready')



Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)


Template.registerHelper 'author', ->
    Meteor.users.findOne(@_author_id)


Template.registerHelper 'is_loading', -> Session.get 'is_loading'
Template.registerHelper 'dev', -> Meteor.isDevelopment
Template.registerHelper 'fixed', (number)->
    # console.log number
    (number*100).toFixed()
Template.registerHelper 'to_percent', (number)->
    # console.log number
    (number*100).toFixed()

Template.registerHelper 'loading_class', ()->
    if Session.get 'loading' then 'disabled' else ''

Template.registerHelper 'when', ()-> moment(@_timestamp).fromNow()
Template.registerHelper 'from_now', (input)-> moment(input).fromNow()

Template.registerHelper 'in_dev', ()-> Meteor.isDevelopment
