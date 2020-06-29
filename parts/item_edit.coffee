if Meteor.isClient
    Router.route '/item/:doc_id/edit', (->
        @layout 'layout'
        @render 'item_edit'
        ), name:'item_edit'

    Template.item_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
        @autorun => Meteor.subscribe 'model_docs', 'item_list'
    Template.item_edit.onRendered ->
        Meteor.setTimeout ->
            $('.accordion').accordion()
        , 1000
    Template.item_edit.events
        'click .clear_item_list': ->
            item = Docs.findOne Router.current().params.doc_id
            Docs.update item._id,
                $unset:item_list_id:1
    Template.item_edit.helpers
        item_list: ->
            item = Docs.findOne Router.current().params.doc_id
            Docs.findOne
                _id: item.item_list_id
                model:'item_list'
        choices: ->
            Docs.find
                model:'choice'
                item_id:@_id
    Template.item_edit.events
