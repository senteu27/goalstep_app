class AiChatsController < ApplicationController
  before_action :authenticate_user!

  def create
    history = current_user.chat_messages.order(:id).map do |chat_message|
      {
        role: chat_message.role,
        content: chat_message.content
      }
    end

    uri = URI("https://api.groq.com/openai/v1/chat/completions")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Authorization"] =
      "Bearer #{Rails.application.credentials.dig(:groq, :api_key)}"
    request["Content-Type"] = "application/json"

    request.body = {
      model: "openai/gpt-oss-120b",
      messages: [
        {
          role: "system",
          content: <<~PROMPT
            あなたは目標達成を支援するアシスタントです。

            以下のルールを守って回答してください。
            ・回答はできるだけ短く、簡潔にする
            ・長い説明や大量の箇条書きは避ける
            ・表は基本的に使用しない
            ・一度にたくさんの質問をしない
            ・必要な場合は質問を1つずつ行う
            ・ユーザーの目標に合った行動や障害を一緒に考える
            ・専門的な内容も初心者に分かる言葉で説明する
            ・最初から詳細な計画を押し付けず、会話しながら整理する
            ・健康など安全性が重要な話題では、無理な方法を勧めない
            ・直前の発言だけでなく、それまでの会話全体を踏まえて回答する
            ・ユーザーの言葉に誤字や省略、曖昧な表現があっても、会話の流れから意味を推測する
            ・意味が複数考えられる場合は、勝手に決めつけず短く確認する
            ・ユーザーの本来の相談内容や目標から話題を逸らさない
            ・単語の意味を聞かれていない限り、言葉の辞書的な説明をしない
            ・ユーザーの発言を否定せず、自然な会話を心がける
            ・質問ばかりせず、情報がある程度そろったら具体的な提案を始める
            ・ユーザーが大まかな希望しか伝えていなくても、現時点でできる提案をする
            ・質問する場合も、質問だけで回答を終わらせない
            ・実現が難しい希望については、理由と代替案を説明する
            ・初心者には簡単で安全な方法から提案する
            ・期間や回数などの計算に矛盾がないか確認する
            ・説明するときは改行などをして見えやすいようにする
          PROMPT
        }
      ] + history + [
        {
          role: "user",
          content: params[:message]
        }
      ]
    }.to_json

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      answer = JSON.parse(response.body).dig("choices", 0, "message", "content")

      current_user.chat_messages.create!(
        role: "user",
        content: params[:message]
      )

      current_user.chat_messages.create!(
        role: "assistant",
        content: answer
      )

      render json: { answer: answer }
    else
      Rails.logger.error("Groq API error: #{response.code} #{response.body}")
      render json: { error: "AIとの通信に失敗しました。" },
             status: :bad_gateway
    end
  end
end