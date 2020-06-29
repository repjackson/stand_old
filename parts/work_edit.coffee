if Meteor.isClient
    Template.work_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
        @autorun => Meteor.subscribe 'model_docs', 'work_list'
    Template.work_edit.onRendered ->
        Meteor.setTimeout ->
            $('.accordion').accordion()
        , 1000
    Template.work_edit.events
        'click .clear_work_list': ->
            work = Docs.findOne Router.current().params.doc_id
            Docs.update work._id,
                $unset:work_list_id:1
    Template.work_edit.helpers
        work_list: ->
            work = Docs.findOne Router.current().params.doc_id
            Docs.findOne
                _id: work.work_list_id
                model:'work_list'
        choices: ->
            Docs.find
                model:'choice'
                work_id:@_id
    Template.work_edit.events
