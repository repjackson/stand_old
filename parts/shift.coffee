if Meteor.isClient
    Router.route '/shifts', (->
        @layout 'layout'
        @render 'shifts'
        ), name:'shifts'
    Router.route '/shift/:doc_id/view', (->
        @layout 'layout'
        @render 'shift_view'
        ), name:'shift_view'
    Router.route '/shift/:doc_id/edit', (->
        @layout 'layout'
        @render 'shift_edit'
        ), name:'shift_edit'

    @selected_shift_tags = new ReactiveArray []
    @selected_shift_roles = new ReactiveArray []


    Template.shift_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.shift_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id



    Template.shift_cloud.onCreated ->
        @autorun -> Meteor.subscribe('shift_tags',
            selected_shift_tags.array()
            selected_shift_roles.array()
            Session.get('view_mode')
        )
        Session.setDefault('view_mode', 'shifts')

    Template.shift_cloud.helpers
        all_tags: ->
            shift_count = Meteor.shifts.find().count()
            if 0 < shift_count < 3 then Badge_tags.find { count: $lt: shift_count } else Badge_tags.find()

        selected_shift_tags: ->
            # model = 'event'
            # console.log "selected_#{model}_tags"
            selected_shift_tags.array()


    Template.shift_cloud.events
        'click .select_tag': -> selected_shift_tags.push @name
        'click .unselect_tag': -> selected_shift_tags.remove @valueOf()
        'click #clear_tags': -> selected_shift_tags.clear()




    Template.shifts.onCreated ->
        @autorun -> Meteor.subscribe 'selected_shifts', selected_shift_tags.array()

    Template.shifts.events
        'click .add_shift': ->
            new_shift_id =
                Docs.insert
                    model:'shift'
            Router.go "/shift/#{new_shift_id}/edit"
    Template.shifts.helpers
        shifts: ->
            match = {model:'shift'}
            if selected_shift_tags.array().length > 0 then match.tags = $all: selected_shift_tags.array()
            Docs.find match

    Template.shift_item.helpers


    Template.shift_item.events

    Template.shift_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.shift_view.onRendered ->


    Template.shift_view.events
        'click .delete_item': ->
            if confirm 'delete item?'
                Docs.remove @_id

        'click .submit': ->
            if confirm 'confirm?'
                Meteor.call 'send_shift', @_id, =>
                    Router.go "/shift/#{@_id}/view"


    Template.shift_view.helpers
    Template.shift_view.events

# if Meteor.isServer
#     Meteor.methods
        # send_shift: (shift_id)->
        #     shift = Docs.findOne shift_id
        #     target = Meteor.users.findOne shift.target_id
        #     sender = Meteor.users.findOne shift._author_id
        #
        #     console.log 'sending shift', shift
        #     Meteor.users.update target._id,
        #         $inc:
        #             points: shift.amount
        #     Meteor.users.update sender._id,
        #         $inc:
        #             points: -shift.amount
        #     Docs.update shift_id,
        #         $set:
        #             submitted:true
        #             submitted_timestamp:Date.now()
        #
        #
        #
        #     Docs.update Router.current().params.doc_id,
        #         $set:
        #             submitted:true

if Meteor.isServer
    Meteor.publish 'selected_shifts', (selected_shift_tags)->
        match = {model:'shift'}
        if selected_shift_tags.length > 0 then match.tags = $all: selected_shift_tags
        Docs.find match
        # if Meteor.shift()
        #     if 'admin' in Meteor.shift().roles
        #         Meteor.shifts.find()
        #     else
        #         Meteor.shifts.find(
        #             # levels:$in:['l1']
        #             roles:$in:['member']
        #         )
        # else
        #     Meteor.shifts.find(
        #         levels:$in:['member']
        #     )



    Meteor.publish 'shift_tags', (
        selected_shift_tags,
        view_mode
        limit
    )->
        self = @
        match = {model:'shift'}
        if selected_shift_tags.length > 0 then match.tags = $all: selected_shift_tags
        # match.model = 'item'
        # if view_mode is 'shifts'
        #     match.bought = $ne:true
        #     match._author_id = $ne: Meteor.shiftId()
        # if view_mode is 'bought'
        #     match.bought = true
        #     match.buyer_id = Meteor.shiftId()
        # if view_mode is 'selling'
        #     match.bought = $ne:true
        #     match._author_id = Meteor.shiftId()
        # if view_mode is 'sold'
        #     match.bought = true
        #     match._author_id = Meteor.shiftId()

        cloud = Docs.aggregate [
            { $match: match }
            { $project: "tags": 1 }
            { $unwind: "$tags" }
            { $group: _id: "$tags", count: $sum: 1 }
            { $match: _id: $nin: selected_shift_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]

        # console.log 'filter: ', filter
        # console.log 'cloud: ', cloud

        cloud.forEach (shift_tag, i) ->
            self.added 'shift_tags', Random.id(),
                name: shift_tag.name
                count: shift_tag.count
                index: i

        self.ready()
