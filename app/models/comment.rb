# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_type :string
#  commentable_id   :integer
#  commented_by     :integer
#  message          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  commenter        :string
#
# Indexes
#
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#

class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  validates :message, :presence => true, :length => { :maximum => 400 }

  after_create :send_notification
  def as_json
    {
      id: id,
      message: message,
      commenter: {
        id: commented_by,
        first_name: "",
        last_name: "",
      },
      created_at: created_at,
      updated_at: updated_at
    }
  end

  def send_notification
    bookmark = self.commentable.bookmark
    grade_id = bookmark.grade_id
    subject_id = bookmark.subject_id
    header_hash = {
      title: "New Comment Added",
      body:  bookmark.title,
      sound: 'default',
    }

    if self.commentable.is_a?(Collaboration)
      body_hash = {
        type: 'collaboration_comment',
        id: self.id,
        collaboration_id: self.commentable.bookmark_id
      }
      associated_teacher_ids = GradeTeacher.where(grade_id:grade_id, subject_id: subject_id).pluck(:teacher_id)
      teachers = Teacher.where(id: associated_teacher_ids)
      teachers.each do |teacher|
        android_registration_ids = teacher.devices.active.android.pluck(:token)
        if android_registration_ids.present?
          android_options = {
            priority: "high",
            content_available: true,
            data: header_hash.merge!(body_hash)
          }
          NotificationWorker.perform_async(android_registration_ids, android_options, TEACHER_FCM_KEY)
        end

        ios_registration_ids = teacher.devices.active.ios.pluck(:token)
        if ios_registration_ids.present?
          ios_options = {
            notification: header_hash,
            priority: "high",
            content_available: true,
            data: body_hash
          }
          NotificationWorker.perform_async(ios_registration_ids, ios_options, TEACHER_FCM_KEY)
        end
      end
    else
      body_hash = {
        type: 'followup_comment',
        id: self.id,
        followup_id: self.commentable.bookmark_id
      }
      associated_student_ids = StudentProfile.where(grade_id: grade_id).pluck(:student_id)
      students = Student.active.where(id: associated_student_ids)
      students.each do |student|
        android_registration_ids = student.parent.devices.active.android.pluck(:token)
        if android_registration_ids.present?
          android_options = {
            priority: "high",
            content_available: true,
            data: header_hash.merge!(body_hash)
          }
          NotificationWorker.perform_async(android_registration_ids, android_options, PARENT_FCM_KEY)
        end

        ios_registration_ids = student.parent.devices.active.ios.pluck(:token)
        if ios_registration_ids.present?
          ios_options = {
            notification: header_hash,
            priority: "high",
            content_available: true,
            data: body_hash
          }
          NotificationWorker.perform_async(ios_registration_ids, ios_options, PARENT_FCM_KEY)
        end
      end

    end
  end

end
