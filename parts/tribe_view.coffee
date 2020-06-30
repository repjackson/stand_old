if Meteor.isClient
    Router.route '/tribe/:doc_id/view', (->
        @layout 'layout'
        @render 'tribe_view'
        ), name:'tribe_view'

    Template.tribe_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
