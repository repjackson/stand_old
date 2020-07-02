if Meteor.isClient
    Router.route '/spend/:doc_id/edit', (->
        @layout 'layout'
        @render 'spend_edit'
        ), name:'spend_edit'

    Template.spend_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.spend_edit.onRendered ->
    Template.spend_edit.events
        'click .delete_item': ->
            if confirm 'delete item?'
                Docs.remove @_id

    Template.spend_edit.helpers
    Template.spend_edit.events
