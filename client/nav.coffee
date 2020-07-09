Template.nav.onCreated ->
    @autorun => Meteor.subscribe 'me'
    # @autorun => Meteor.subscribe 'all_users'


Template.nav.events
    'click .set_user': ->
        Session.set 'loading', true
        Meteor.call 'set_facets', 'user', ->
            Session.set 'loading', false
    'click .set_shift': ->
        Session.set 'loading', true
        Meteor.call 'set_facets', 'shift', ->
            Session.set 'loading', false
    'click .set_model': ->
        Session.set 'loading', true
        Meteor.call 'set_facets', 'model', ->
            Session.set 'loading', false
    'click .set_shop': ->
        Session.set 'loading', true
        Meteor.call 'set_facets', 'shop', ->
            Session.set 'loading', false
