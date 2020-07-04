Template.nav.onCreated ->
    @autorun => Meteor.subscribe 'me'
    @autorun => Meteor.subscribe 'all_users'


Template.nav.events
    'click .set_user': ->
        Session.set 'loading', true
        Meteor.call 'set_facets', 'user', ->
            Session.set 'loading', false
