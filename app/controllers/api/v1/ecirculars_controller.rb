class Api::V1::EcircularsController < Api::V1::BaseController

  # params to create ecircular
  # {
  #   title: string,
  #   body: string,
  #   circular_tag:
  #   recepients: {
  #     grade1_id: [div1_id, div2_id],
  #     grade2_id: [div1_id, div2_id]
  #   },
  #   attachments: [
  #   {original_file_name: 'abc.pdf', s3_url: 'htt[p://abc/def/abc.pdf]'},
  #   {original_file_name: 'abc.pdf', s3_url: 'htt[p://abc/def/abc.pdf]'},
  #   {original_file_name: 'abc.pdf', s3_url: 'htt[p://abc/def/abc.pdf]'}
  # ]
  # }
  def create

  end


  def tags
    circular_tags = ['lesson_plan', 'exam_time_table', 'my_result', 'my_attendance', 'class_timetable', 'sample_papers',
                     'transport_details', 'holiday_circular', 'medical_visit_report', 'news_and_events', 'important_announcement', 'event_circular',
                     'awards_and_achievements', 'fee_notice', 'follow_up_activity_for_parents', 'exhibitions' 'worksheets',
                     'extra_curricular_activities_circular', 'school_time_change', 'inter_school_competitions', 'intra_school_competitions', 'olympiads']

    tags_data = []
    circular_tags.each do |circular_tag|
      tags_data << {"#{circular_tag}": circular_tag.humanize}
    end

    render json: {
      success: true,
      error: nil,
      data: {
        tags: tags_data
      }
    }
  end

end