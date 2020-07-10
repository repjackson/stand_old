
Template.registerHelper 'in_role', (role)->
    if Meteor.user() and Meteor.user().roles
        if role in Meteor.user().roles
            true
        else
            false
    else
        false

Template.registerHelper 'is_in_admin', () ->
    Meteor.user() and Meteor.userId() in ['vwCi2GTJgvBJN5F6c','Dw2DfanyyteLytajt']
Template.registerHelper 'current_user', () ->
    Meteor.users.findOne username:Router.current().params.username

Template.registerHelper 'is_current_user', () ->
    if Meteor.user()
        Meteor.user().username is Router.current().params.username

Template.registerHelper 'target', () ->
    Meteor.users.findOne @target_id
Template.registerHelper 'upvote_class', () ->
    if Meteor.userId()
        if @upvoter_ids and Meteor.userId() in @upvoter_ids then 'green' else 'outline'
    else ''
Template.registerHelper 'downvote_class', () ->
    if Meteor.userId()
        if @downvoter_ids and Meteor.userId() in @downvoter_ids then 'red' else 'outline'
    else ''

Template.registerHelper 'current_month', () -> moment(Date.now()).format("MMMM")
Template.registerHelper 'current_day', () -> moment(Date.now()).format("DD")



# Template.registerHelper 'field_value', () ->
#     # console.log @
#     parent = Template.parentData()
#     # console.log 'parent', parent
#     if parent
#         parent["#{@key}"]

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
        'admin' in Meteor.user().roles or @_author_id is Meteor.userId()



Template.registerHelper 'current_doc', () ->
    found_doc = Docs.findOne Router.current().params.doc_id
    if found_doc
        found_doc
    else
        Meteor.users.findOne Router.current().params.doc_id

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


Template.registerHelper 'dev', -> Meteor.isDevelopment
Template.registerHelper 'fixed', (number)->
    # console.log number
    number.toFixed(2)
    # (number*100).toFixed()
Template.registerHelper 'to_percent', (number)->
    # console.log number
    (number*100).toFixed()

Template.registerHelper 'upvote_class', () ->
    if Meteor.userId()
        if @upvoter_ids and Meteor.userId() in @upvoter_ids then 'green' else 'outline'
    else ''
Template.registerHelper 'downvote_class', () ->
    if Meteor.userId()
        if @downvoter_ids and Meteor.userId() in @downvoter_ids then 'red' else 'outline'
    else ''

Template.registerHelper 'current_month', () -> moment(Date.now()).format("MMMM")
Template.registerHelper 'current_day', () -> moment(Date.now()).format("DD")

Template.registerHelper 'can_buy', ()->
    Meteor.userId() isnt @_author_id

Template.registerHelper 'has_enough', ()->
    Meteor.user().credit > @price



Template.registerHelper 'session_is', (key, value)->
    Session.equals(key, value)

Template.registerHelper 'is_loading', -> Session.get 'loading'
Template.registerHelper 'long_time', (input)-> moment(input).format("h:mm a")
Template.registerHelper 'long_date', (input)-> moment(input).format("dddd, MMMM Do h:mm a")
Template.registerHelper 'short_date', (input)-> moment(input).format("dddd, MMMM Do")
Template.registerHelper 'med_date', (input)-> moment(input).format("MMM D 'YY")
Template.registerHelper 'medium_date', (input)-> moment(input).format("MMMM Do YYYY")
Template.registerHelper 'medium_date', (input)-> moment(input).format("dddd, MMMM Do YYYY")
Template.registerHelper 'today', -> moment(Date.now()).format("dddd, MMMM Do a")
Template.registerHelper 'int', (input)-> input.toFixed(0)
Template.registerHelper 'when', ()-> moment(@_timestamp).fromNow()
Template.registerHelper 'from_now', (input)-> moment(input).fromNow()
Template.registerHelper 'cal_time', (input)-> moment(input).calendar()

Template.registerHelper 'current_month', ()-> moment(Date.now()).format("MMMM")
Template.registerHelper 'current_day', ()-> moment(Date.now()).format("DD")


Template.registerHelper 'loading_class', ()->
    if Session.get 'loading' then 'disabled' else ''

# Template.registerHelper 'publish_when', ()-> moment(@publish_date).fromNow()

Template.registerHelper 'in_dev', ()-> Meteor.isDevelopment

Template.registerHelper 'is_eric', ()-> if Meteor.userId() and Meteor.userId() in ['K77p8B9jpXbTz6nfD'] then true else false
Template.registerHelper 'publish_when', ()-> moment(@publish_date).fromNow()





Template.registerHelper 'loading_class', ()->
    if Session.get 'loading' then 'disabled' else ''

Template.registerHelper 'when', ()-> moment(@_timestamp).fromNow()
Template.registerHelper 'from_now', (input)-> moment(input).fromNow()

Template.registerHelper 'in_dev', ()-> Meteor.isDevelopment
