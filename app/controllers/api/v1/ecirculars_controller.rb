class Api::V1::EcircularsController < Api::V1::BaseController

  # circulars = [
  #   {
  #     id: 1,
  #     title: 'title',
  #     body: 'body',
  #     created_by: 'Kapil Bhosale'
  #     created on: 'Oct 18, 2016, 4:12 PM'
  #     circular_tag: {
  #       id: 2,
  #       name: 'Holiday'
  #     },
  #     recipients:[
  #       {grade_id: 1, grade_name: 'grade I', divisions: [{div_id: 1, div_name: 'A'},{div_id: 2, div_name: 'B'}]},
  #       {grade_id: 2, grade_name: 'grade I', divisions: [{div_id: 1, div_name: 'A'},{div_id: 2, div_name: 'B'}]}
  #     ],
  #     attachments: [
  #       {original_file_name: 'file 1', s3_url: 'https://aws.bucket.com/schloopstg/abc.pdf'},
  #       {original_file_name: 'file 2', s3_url: 'https://aws.bucket.com/schloopstg/abc.pdf'},
  #       {original_file_name: 'file 3', s3_url: 'https://aws.bucket.com/schloopstg/abc.pdf'}
  #     ]
  #   },
  #   {
  #     id: 2,
  #     title: 'title',
  #     body: 'body',
  #     created_by: 'Kapil Bhosale'
  #     created on: 'Oct 18, 2016, 4:12 PM'
  #     circular_tag: {
  #       id: 2,
  #       name: 'Holiday'
  #     },
  #     recipients:[
  #       {grade_id: 1, grade_name: 'grade I', divisions: [{div_id: 1, div_name: 'A'},{div_id: 2, div_name: 'B'}]},
  #       {grade_id: 1, grade_name: 'grade I', divisions: [{div_id: 1, div_name: 'A'},{div_id: 2, div_name: 'B'}]}
  #     ],
  #     attachments: [
  #       {original_file_name: 'file 1', s3_url: 'https://aws.bucket.com/schloopstg/abc.pdf'},
  #       {original_file_name: 'file 2', s3_url: 'https://aws.bucket.com/schloopstg/abc.pdf'},
  #       {original_file_name: 'file 3', s3_url: 'https://aws.bucket.com/schloopstg/abc.pdf'}
  #     ]
  #   }
  # ]
  def index
    errors, circular_data = [], []
    @school = School.find_by(id: @current_user.school_id)
    page = params[:page].to_s.to_i
    offset = (page * 10)
    if @school.blank?
      errors << "school not found."
    else
      circulars = @school.ecirculars.includes(:attachments, ecircular_recipients: [:grade, :division]).order(id: :desc).offset(offset).limit(10)
      circulars.each do |circular|
        recipients, attachments = [], []
        grouped_circulars = circular.ecircular_recipients.group_by do |x| x.grade_id end
        grades_by_id = Grade.where(id: grouped_circulars.keys).index_by(&:id)
        grouped_circulars.each do |grade_id, recipients_data|
          recipient = {grade_id: grade_id, grade_name: grades_by_id[grade_id].name}
          recipient[:divisions] = []
          recipients_data.each do |rec|
            recipient[:divisions] << {div_id: rec.division_id, div_name: rec.division.name}
          end
          recipients << recipient
        end
        circular.attachments.select(:id, :original_filename, :name).each do |attachment|
          attachments << {original_filename: attachment.original_filename, s3_url: attachment.name}
        end
        created_by = circular.created_by_type.classify.safe_constantize.find_by(id: circular.created_by_id)
        circular_data << {
          id: circular.id,
          title: circular.title,
          body: circular.body,
          created_by: { id: created_by.id, name: created_by.name },
          created_on: circular.created_at,
          circular_tag: {
            id: Ecircular.circular_tags[circular.circular_tag],
            name: circular.circular_tag.humanize
          },
          recipients: recipients,
          attachments: attachments
        }
      end
    end
    if errors.blank?
      index_response = {
        success: true,
        error: nil,
        data: circular_data
      }
    else
      index_response = {
        success: false,
        error:  {
          code: 0,
          message: errors.flatten
        },
        data: nil
      }
    end
    render json: index_response
  end

  # params to create ecircular
  # {
  #   title: string,
  #   body: string,
  #   circular_tag:
  #   recipients: {
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
    errors = []
    user_type = @current_user.type rescue ''
    if user_type == 'ProductAdmin'
      created_by_type = Ecircular.created_by_types[:product_admin]
    elsif user_type == 'SchoolAdmin'
      created_by_type = Ecircular.created_by_types[:school_admin]
    else
      created_by_type = Ecircular.created_by_types[:teacher]
    end

    circular = Ecircular.create(circular_params.merge!(created_by_type: created_by_type, created_by_id: @current_user.id, school_id: @current_user.school_id ))
    if circular.persisted?
      begin
        circular.ecircular_recipients.create!(recipients_params)
        Attachment.create!(attachments_params(circular))
      rescue Exception => ex
        errors << ex.message
      end
    else
      errors << circular.errors.full_messages
    end

    if errors.blank?
      create_response = {
        success: true,
        error:  nil,
        data: {}
      }
    else
      create_response = {
        success: false,
        error:  {
          code: 0,
          message: errors.flatten
        },
        data: nil
      }
    end
    render json: create_response
  end

  def tags
    tags_data = []
    Ecircular.circular_tags.invert.each do |key, value|
      tags_data << {id: key, name: value.humanize}
    end

    render json: {
      success: true,
      error: nil,
      data: {
        tags: tags_data
      }
    }
  end

  private
    def circular_params
      params.permit(:title, :body, :circular_tag)
    end

    def recipients_params
      create_params = []
      params[:recipients].each do |grade_id, division_ids|
        division_ids.each do |div_id|
          create_params << {
            school_id: @current_user.school_id,
            grade_id: grade_id,
            division_id: div_id
          }
        end
      end
      return create_params
    end

    def attachments_params(circular)
      create_params = []
      params[:attachments].each do |attachment|
        create_params << {
          attachable_id: circular.id,
          attachable_type: circular.class,
          name: attachment[:s3_url],
          original_filename: attachment[:original_file_name],
        }
      end
      return create_params
    end
end