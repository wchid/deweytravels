class Topic < ActiveRecord::Base
	# attr_accessible :

	has_and_belongs_to_many :graphs

	has_many :topic_user_connections, :foreign_key => "expertise_id"
	has_many :experts, :through => :topic_user_connections, :source => :expert

	has_many :topic_topic_connections, :foreign_key => "supertopic_id"
	has_many :supertopics, :through => :second_topic_topic_connections, :source => :supertopic

	has_many :second_topic_topic_connections, :class_name => "TopicTopicConnection", :foreign_key => "subtopic_id"
	has_many :subtopics, :through => :topic_topic_connections, :source => :subtopic

end
