if Meteor.isClient
    Router.route '/item/:doc_id/view', (->
        @layout 'layout'
        @render 'item_view'
        ), name:'item_view'
    Template.item_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
