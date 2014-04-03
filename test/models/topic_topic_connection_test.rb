require 'test_helper'

class TopicTopicConnectionTest < ActiveSupport::TestCase
  test "test_action" do
    topic1 = Topic.new
    topic1.title = "Test1"

    topic2 = Topic.new
    topic2.title = "Test2"

    topic1.save
    topic2.save
    
    old_action_count = Action.count
    topic1.subtopics << topic2
    assert_equal(old_action_count + 1,
                 Action.count)
    
    conn = TopicTopicConnection.find_by subtopic_id: topic2.id, supertopic_id:topic1.id
    assert conn.action
    assert_equal(conn.id, conn.action.table_pkey)
    assert_equal(nil, conn.action.total_vote)
    assert_equal(nil, conn.action.good_vote)
    assert_equal(conn, conn.action.actionable_object)
  end

end
