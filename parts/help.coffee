if Meteor.isClient
    Router.route '/help', (->
        @layout 'layout'
        @render 'help'
        ), name:'help'
    Router.route '/ticket/:doc_id/view', (->
        @layout 'layout'
        @render 'ticket_view'
        ), name:'ticket_view'
    Router.route '/ticket/:doc_id/edit', (->
        @layout 'layout'
        @render 'ticket_edit'
        ), name:'ticket_edit'

    @selected_ticket_tags = new ReactiveArray []
    @selected_ticket_roles = new ReactiveArray []


    Template.ticket_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.ticket_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id



    Template.ticket_cloud.onCreated ->
        @autorun -> Meteor.subscribe('ticket_tags',
            selected_ticket_tags.array()
            selected_ticket_roles.array()
            Session.get('view_mode')
        )
        Session.setDefault('view_mode', 'tickets')

    Template.ticket_cloud.helpers
        all_tags: ->
            ticket_count = Meteor.tickets.find().count()
            if 0 < ticket_count < 3 then Badge_tags.find { count: $lt: ticket_count } else Badge_tags.find()

        selected_ticket_tags: ->
            # model = 'event'
            # console.log "selected_#{model}_tags"
            selected_ticket_tags.array()


    Template.ticket_cloud.events
        'click .select_tag': -> selected_ticket_tags.push @name
        'click .unselect_tag': -> selected_ticket_tags.remove @valueOf()
        'click #clear_tags': -> selected_ticket_tags.clear()




    Template.tickets.onCreated ->
        @autorun -> Meteor.subscribe 'selected_tickets', selected_ticket_tags.array()

    Template.tickets.events
        'click .add_ticket': ->
            new_ticket_id =
                Docs.insert
                    model:'ticket'
            Router.go "/ticket/#{new_ticket_id}/edit"
    Template.tickets.helpers
        tickets: ->
            match = {model:'ticket'}
            if selected_ticket_tags.array().length > 0 then match.tags = $all: selected_ticket_tags.array()
            Docs.find match

    Template.ticket_item.helpers


    Template.ticket_item.events

    Template.ticket_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.ticket_view.onRendered ->


    Template.ticket_view.events
        'click .delete_item': ->
            if confirm 'delete item?'
                Docs.remove @_id

        'click .submit': ->
            if confirm 'confirm?'
                Meteor.call 'send_ticket', @_id, =>
                    Router.go "/ticket/#{@_id}/view"


    Template.ticket_view.helpers
    Template.ticket_view.events

# if Meteor.isServer
#     Meteor.methods
        # send_ticket: (ticket_id)->
        #     ticket = Docs.findOne ticket_id
        #     target = Meteor.users.findOne ticket.target_id
        #     sender = Meteor.users.findOne ticket._author_id
        #
        #     console.log 'sending ticket', ticket
        #     Meteor.users.update target._id,
        #         $inc:
        #             points: ticket.amount
        #     Meteor.users.update sender._id,
        #         $inc:
        #             points: -ticket.amount
        #     Docs.update ticket_id,
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
    Meteor.publish 'selected_tickets', (selected_ticket_tags)->
        match = {model:'ticket'}
        if selected_ticket_tags.length > 0 then match.tags = $all: selected_ticket_tags
        Docs.find match
        # if Meteor.ticket()
        #     if 'admin' in Meteor.ticket().roles
        #         Meteor.tickets.find()
        #     else
        #         Meteor.tickets.find(
        #             # levels:$in:['l1']
        #             roles:$in:['member']
        #         )
        # else
        #     Meteor.tickets.find(
        #         levels:$in:['member']
        #     )



    Meteor.publish 'ticket_tags', (
        selected_ticket_tags,
        view_mode
        limit
    )->
        self = @
        match = {model:'ticket'}
        if selected_ticket_tags.length > 0 then match.tags = $all: selected_ticket_tags
        # match.model = 'item'
        # if view_mode is 'tickets'
        #     match.bought = $ne:true
        #     match._author_id = $ne: Meteor.ticketId()
        # if view_mode is 'bought'
        #     match.bought = true
        #     match.buyer_id = Meteor.ticketId()
        # if view_mode is 'selling'
        #     match.bought = $ne:true
        #     match._author_id = Meteor.ticketId()
        # if view_mode is 'sold'
        #     match.bought = true
        #     match._author_id = Meteor.ticketId()

        cloud = Docs.aggregate [
            { $match: match }
            { $project: "tags": 1 }
            { $unwind: "$tags" }
            { $group: _id: "$tags", count: $sum: 1 }
            { $match: _id: $nin: selected_ticket_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]

        # console.log 'filter: ', filter
        # console.log 'cloud: ', cloud

        cloud.forEach (ticket_tag, i) ->
            self.added 'ticket_tags', Random.id(),
                name: ticket_tag.name
                count: ticket_tag.count
                index: i

        self.ready()
