if Meteor.isClient
    Router.route '/tribe/:doc_id/edit', (->
        @layout 'layout'
        @render 'tribe_edit'
        ), name:'tribe_edit'

    Template.tribe_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.tribe_edit.onRendered ->
    Template.tribe_edit.events
    Template.tribe_edit.helpers
