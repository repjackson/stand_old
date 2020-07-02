if Meteor.isClient
    Router.route '/item/:doc_id/view', (->
        @layout 'layout'
        @render 'spend_view'
        ), name:'spend_view'
    Template.spend_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
