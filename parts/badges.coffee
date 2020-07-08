if Meteor.isClient
    Router.route '/badge/:doc_id/view', (->
        @layout 'layout'
        @render 'badge_view'
        ), name:'badge_view'

    Template.badge_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.badge_view.onRendered ->


    Template.badge_view.events
        'click .delete_item': ->
            if confirm 'delete item?'
                Docs.remove @_id

        'click .submit': ->
            if confirm 'confirm?'
                Meteor.call 'send_badge', @_id, =>
                    Router.go "/badge/#{@_id}/view"


    Template.badge_view.helpers
    Template.badge_view.events

# if Meteor.isServer
#     Meteor.methods
        # send_badge: (badge_id)->
        #     badge = Docs.findOne badge_id
        #     target = Meteor.users.findOne badge.target_id
        #     sender = Meteor.users.findOne badge._author_id
        #
        #     console.log 'sending badge', badge
        #     Meteor.users.update target._id,
        #         $inc:
        #             points: badge.amount
        #     Meteor.users.update sender._id,
        #         $inc:
        #             points: -badge.amount
        #     Docs.update badge_id,
        #         $set:
        #             submitted:true
        #             submitted_timestamp:Date.now()
        #
        #
        #
        #     Docs.update Router.current().params.doc_id,
        #         $set:
        #             submitted:true

if Meteor.isClient
    @selected_badge_tags = new ReactiveArray []
    @selected_badge_roles = new ReactiveArray []


    Router.route '/badges', (->
        @render 'badges'
        ), name:'badges'


    Template.badges.onCreated ->
        @autorun -> Meteor.subscribe 'selected_badges', selected_badge_tags.array()

    Template.badges.helpers
        badges: ->
            match = {model:'badge'}
            if selected_badge_tags.array().length > 0 then match.tags = $all: selected_badge_tags.array()
            Docs.find match

    Template.badge_item.helpers


    Template.badge_item.events




    Template.badge_cloud.onCreated ->
        @autorun -> Meteor.subscribe('badge_tags',
            selected_badge_tags.array()
            selected_badge_roles.array()
            Session.get('view_mode')
        )
        Session.setDefault('view_mode', 'badges')

    Template.badge_cloud.helpers
        all_tags: ->
            badge_count = Meteor.badges.find().count()
            if 0 < badge_count < 3 then Badge_tags.find { count: $lt: badge_count } else Badge_tags.find()

        selected_badge_tags: ->
            # model = 'event'
            # console.log "selected_#{model}_tags"
            selected_badge_tags.array()


    Template.badge_cloud.events
        'click .select_tag': -> selected_badge_tags.push @name
        'click .unselect_tag': -> selected_badge_tags.remove @valueOf()
        'click #clear_tags': -> selected_badge_tags.clear()



if Meteor.isServer
    Meteor.publish 'selected_badges', (selected_badge_tags)->
        match = {model:'badge'}
        if selected_badge_tags.length > 0 then match.tags = $all: selected_badge_tags
        Docs.find match
        # if Meteor.badge()
        #     if 'admin' in Meteor.badge().roles
        #         Meteor.badges.find()
        #     else
        #         Meteor.badges.find(
        #             # levels:$in:['l1']
        #             roles:$in:['member']
        #         )
        # else
        #     Meteor.badges.find(
        #         levels:$in:['member']
        #     )



    Meteor.publish 'badge_tags', (
        selected_badge_tags,
        view_mode
        limit
    )->
        self = @
        match = {model:'badge'}
        if selected_badge_tags.length > 0 then match.tags = $all: selected_badge_tags
        # match.model = 'item'
        # if view_mode is 'badges'
        #     match.bought = $ne:true
        #     match._author_id = $ne: Meteor.badgeId()
        # if view_mode is 'bought'
        #     match.bought = true
        #     match.buyer_id = Meteor.badgeId()
        # if view_mode is 'selling'
        #     match.bought = $ne:true
        #     match._author_id = Meteor.badgeId()
        # if view_mode is 'sold'
        #     match.bought = true
        #     match._author_id = Meteor.badgeId()

        cloud = Docs.aggregate [
            { $match: match }
            { $project: "tags": 1 }
            { $unwind: "$tags" }
            { $group: _id: "$tags", count: $sum: 1 }
            { $match: _id: $nin: selected_badge_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]

        # console.log 'filter: ', filter
        # console.log 'cloud: ', cloud

        cloud.forEach (badge_tag, i) ->
            self.added 'badge_tags', Random.id(),
                name: badge_tag.name
                count: badge_tag.count
                index: i

        self.ready()
