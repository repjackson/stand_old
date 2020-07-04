if Meteor.isClient
    Template.user_info_tag.onCreated ->
        # console.log @
        @autorun => Meteor.subscribe 'term_by_name', @data


    Template.user_info_tag.helpers
        term: ->
            console.log @
            Terms.findOne
                title:@valueOf()



if Meteor.isServer
    Meteor.publish 'term_by_name', (term)->
        console.log term
        Terms.find
            title:term
#     # Meteor.methods
#     #     accept_request: (request)->
#     #         console.log request
#     #         Docs.update request._id,
#     #             $set:
#     #                 approved:true
#     #                 approved_timestamp:Date.now()
#     #         Docs.insert
#     #             model:'alert'
#     #             target_user_id:request._author_id
#     #             content:"Your tutalege request with has been accepted."
#     #
#     #     request_tutelage: (target_user_id)->
#     #         tutor = Meteor.users.findOne target_user_id
#     #         Docs.insert
#     #             model:'tutalege_request'
#     #             tutor_id: target_user_id
#     #             tutor_username:tutor.username
#     #             approved:false
#     #             rejected:false
#     #         Docs.insert
#     #             model:'alert'
#     #             target_user_id:target_user_id
#     #             content:"#{Meteor.user().username} requested your tutalege."
#     #             read:false
#     #
#     #     calc_user_internship_stats: (user_id)->
#     #         user = Meteor.users.findOne user_id
#     #         internship_cursor =
#     #             Docs.find
#     #                 model:'internship'
#     #                 _author_id: user_id
#     #         total_points = 0
#     #         total_upvotes = 0
#     #         total_downvotes = 0
#     #         for internship in internship_cursor.fetch()
#     #             if internship.points
#     #                 total_points += internship.points
#     #             if internship.upvotes
#     #                 total_upvotes += internship.upvotes
#     #             if internship.downvotes
#     #                 total_downvotes += internship.downvotes
#     #
#     #         Meteor.users.update user_id,
#     #             $set:
#     #                 total_internship_points: total_points
#     #                 total_internship_upvotes: total_upvotes
#     #                 total_internship_downvotes: total_downvotes
#     #
#     #     recalc_similar_right: (user_id)->
#     #         user = Meteor.users.findOne user_id
#     #         console.log user.right_tag_cloud
#     #
#     #         right_tag_list = Meteor.users.findOne(user_id).right_tag_list
#     #         console.log right_tag_list
#     #         users = Meteor.users.find({}).fetch()
#     #         right_unions = []
#     #         for user in users
#     #             console.log 'right tag list', right_tag_list
#     #             union = _.intersection user.right_tag_list, right_tag_list
#     #             console.log union
#     #             Meteor.users.update user_id,
#     #                 $addToSet:
#     #                     right_unions:
#     #                         user_id: user._id
#     #                         username: user.username
#     #                         union_count: union.length
#     #                         union:union
#     #
#     #     recalc_opposite_right: (user_id)->
#     #         user = Meteor.users.findOne user_id
#     #         console.log user.right_tag_cloud
#     #
#     #         right_tag_list = Meteor.users.findOne(user_id).right_tag_list
#     #         console.log right_tag_list
#     #         users = Meteor.users.find({}).fetch()
#     #         right_unions = []
#     #         Meteor.users.update user_id,
#     #             $set:
#     #                 right_opposite_unions: []
#     #
#     #         for user in users
#     #             console.log 'right tag list', right_tag_list
#     #             union = _.intersection user.wrong_tag_list, right_tag_list
#     #             console.log union
#     #             Meteor.users.update user_id,
#     #                 $addToSet:
#     #                     right_opposite_unions:
#     #                         user_id: user._id
#     #                         username: user.username
#     #                         union_count: union.length
#     #                         union: union
#     #
#     #
#     #
#     #
#     #     recalc_similar_wrong: (user_id)->
#     #         user = Meteor.users.findOne user_id
#     #     calc_wrong_question_ids: (user_id)->
#     #         user = Meteor.users.findOne user_id
#     #         internship_sessions =
#     #             Docs.find
#     #                 model:'internship_session'
#     #                 _author_id: user_id
#     #         all_wrong_ids = []
#     #         for internship_session in internship_sessions.fetch()
#     #             wrong_answers = _.where(internship_session.answers, {first_choice_correct:false})
#     #             # console.log wrong_answers
#     #             question_wrong_ids = _.pluck(wrong_answers, 'question_id')
#     #             # console.log question_wrong_ids
#     #             # all_wrong_ids.concat question_wrong_ids
#     #             Meteor.users.update user_id,
#     #                 $addToSet:
#     #                     all_wrong_ids: $each: question_wrong_ids
#     #
#     #
#     #     calc_right_question_ids: (user_id)->
#     #         user = Meteor.users.findOne user_id
#     #         internship_sessions =
#     #             Docs.find
#     #                 model:'internship_session'
#     #                 _author_id: user_id
#     #         # all_right_ids = []
#     #         for internship_session in internship_sessions.fetch()
#     #             right_answers = _.where(internship_session.answers, {first_choice_correct:true})
#     #             # console.log 'right answers', right_answers
#     #             question_right_ids = _.pluck(right_answers, 'question_id')
#     #             # console.log 'question right ids', question_right_ids
#     #             # all_right_ids.concat question_right_ids
#     #             Meteor.users.update user_id,
#     #                 $addToSet:
#     #                     all_right_ids: $each: question_right_ids
#     #
#     #
#     #
#     #
#     #     recalc_fiq: (user_id)->
#     #         console.log user_id
#     #         answer_count =
#     #             Docs.find(
#     #                 model:'answer_session'
#     #                 _author_id: user_id
#     #             ).count()
#     #         fiq = answer_count
#     #         Meteor.users.update user_id,
#     #             $set:
#     #                 answer_count: answer_count
#     #                 fiq: fiq
