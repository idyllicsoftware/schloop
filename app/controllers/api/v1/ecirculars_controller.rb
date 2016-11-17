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
    tags_data = []
    Ecircular.circular_types.invert.each do |key, value|
      tags_data << {key => value.humanize}
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