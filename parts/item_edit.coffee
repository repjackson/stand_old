if Meteor.isClient
    Router.route '/item/:doc_id/edit', (->
        @layout 'layout'
        @render 'item_edit'
        ), name:'item_edit'

    Template.item_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.item_edit.onRendered ->
    Template.item_edit.events
        'click .delete_item': ->
            if confirm 'delete item?'
                Docs.remove @_id

    Template.item_edit.helpers
    Template.item_edit.events
