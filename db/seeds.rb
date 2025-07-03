# 朝ストレッチ・美呼吸アプリのシードデータ

# ストレッチデータ
stretches = [
  {
    name: "肩こり解消肩回し",
    description: "両肩を大きく回して、一日の疲れをリセット。ゆっくりと10回ずつ前回し、後ろ回しをしましょう。",
    category: "肩・首",
    duration: 3,
    difficulty: "初級"
  },
  {
    name: "お腹ひねりストレッチ",
    description: "座ったまま、上半身を左右にひねってウエストをすっきり。呼吸を意識しながらゆっくりと。",
    category: "ウエスト",
    duration: 2,
    difficulty: "初級"
  },
  {
    name: "寝起きの太陽礼拝（簡易）",
    description: "朝の太陽に向かって手を合わせ、全身を伸ばして一日のエネルギーをチャージ。",
    category: "全身",
    duration: 5,
    difficulty: "初級"
  },
  {
    name: "足首まわし",
    description: "座ったまま足首をゆっくり回して、むくみを解消。左右それぞれ10回ずつ。",
    category: "足",
    duration: 2,
    difficulty: "初級"
  },
  {
    name: "壁を使った背筋ストレッチ",
    description: "壁に手をついて、背中を伸ばして姿勢を整える。美しい背筋ラインを作りましょう。",
    category: "背中",
    duration: 3,
    difficulty: "初級"
  },
  {
    name: "猫のポーズ",
    description: "四つん這いになって、背中を丸めたり反らしたり。背骨を柔らかくします。",
    category: "背中",
    duration: 2,
    difficulty: "初級"
  },
  {
    name: "腰回し",
    description: "立ったまま腰をゆっくり回して、骨盤の動きをスムーズに。左右それぞれ5回ずつ。",
    category: "腰",
    duration: 3,
    difficulty: "初級"
  },
  {
    name: "腕伸ばし",
    description: "両腕を上に伸ばして、体側も一緒に伸ばす。すっきりとした上半身を作りましょう。",
    category: "腕・胸",
    duration: 2,
    difficulty: "初級"
  },
  {
    name: "首回し",
    description: "首をゆっくり回して、緊張をほぐす。朝の目覚めをスッキリさせます。",
    category: "首",
    duration: 2,
    difficulty: "初級"
  },
  {
    name: "深呼吸ストレッチ",
    description: "大きく息を吸いながら腕を上げ、吐きながら下ろす。心も体もリフレッシュ。",
    category: "全身",
    duration: 3,
    difficulty: "初級"
  }
]

stretches.each do |stretch_data|
  Stretch.find_or_create_by!(name: stretch_data[:name]) do |stretch|
    stretch.description = stretch_data[:description]
    stretch.category = stretch_data[:category]
    stretch.duration = stretch_data[:duration]
    stretch.difficulty = stretch_data[:difficulty]
  end
end

# 呼吸法データ
breathing_exercises = [
  {
    name: "腹式呼吸（4-4-4）",
    description: "4秒かけて息を吸い、4秒止めて、4秒かけて吐く。心を落ち着かせる基本の呼吸法。",
    technique: "4-4-4呼吸法",
    duration: 3,
    benefit: "リラックス効果"
  },
  {
    name: "鼻呼吸だけでリラックス",
    description: "口を閉じて鼻だけで呼吸。ゆっくりと深く、心を静める呼吸を意識しましょう。",
    technique: "鼻呼吸",
    duration: 2,
    benefit: "集中力向上"
  },
  {
    name: "口をすぼめて細く長く吐く呼吸",
    description: "口をすぼめて、ろうそくの火を消すように細く長く息を吐く。肺をしっかりと空にします。",
    technique: "口すぼめ呼吸",
    duration: 2,
    benefit: "肺機能向上"
  },
  {
    name: "1分マインドフルネス呼吸",
    description: "呼吸に意識を向けて、今この瞬間に集中。心の雑念を手放しましょう。",
    technique: "マインドフルネス",
    duration: 1,
    benefit: "ストレス軽減"
  },
  {
    name: "朝の活力呼吸",
    description: "朝日を浴びながら、大きく息を吸って新しい一日のエネルギーをチャージ。",
    technique: "朝活呼吸",
    duration: 3,
    benefit: "活力向上"
  },
  {
    name: "美肌呼吸",
    description: "顔の筋肉をリラックスさせながら、美しさを内側から育てる呼吸法。",
    technique: "美肌呼吸",
    duration: 2,
    benefit: "美容効果"
  },
  {
    name: "肩の力を抜く呼吸",
    description: "肩の力を抜いて、緊張をほぐす呼吸。一日の疲れをリセットします。",
    technique: "脱力呼吸",
    duration: 2,
    benefit: "緊張緩和"
  },
  {
    name: "心のバランス呼吸",
    description: "左右の鼻の穴を交互に使って、心身のバランスを整える呼吸法。",
    technique: "交代鼻呼吸",
    duration: 3,
    benefit: "バランス調整"
  },
  {
    name: "感謝の呼吸",
    description: "感謝の気持ちを込めて呼吸。心が温かくなる呼吸法です。",
    technique: "感謝呼吸",
    duration: 2,
    benefit: "心の安定"
  },
  {
    name: "夜の安らぎ呼吸",
    description: "一日の終わりに、心を落ち着かせる深い呼吸。安らかな眠りを誘います。",
    technique: "安らぎ呼吸",
    duration: 3,
    benefit: "安眠効果"
  }
]

breathing_exercises.each do |breathing_data|
  BreathingExercise.find_or_create_by!(name: breathing_data[:name]) do |breathing|
    breathing.description = breathing_data[:description]
    breathing.technique = breathing_data[:technique]
    breathing.duration = breathing_data[:duration]
    breathing.benefit = breathing_data[:benefit]
  end
end

# 日替わりメッセージデータ
daily_messages = [
  {
    message: "美は1日にして成らず。今日も一歩ずつ、美しい自分に向かって。",
    category: "応援"
  },
  {
    message: "朝の5分が、あなたの一日を変える。今日も素敵な一日を。",
    category: "励まし"
  },
  {
    message: "呼吸は命のリズム。今日も丁寧に呼吸して、心を整えましょう。",
    category: "癒し"
  },
  {
    message: "昨日のあなた、えらい！今日も頑張らなくてOK。",
    category: "褒め"
  },
  {
    message: "忙しい朝に、ちょっとだけ自分時間。あなたのペースで。",
    category: "優しさ"
  },
  {
    message: "体が喜ぶことを、今日も一つ。小さな積み重ねが大きな変化を。",
    category: "気づき"
  },
  {
    message: "深呼吸で、新しい一日の扉を開けましょう。",
    category: "希望"
  },
  {
    message: "あなたの体は、あなたの味方。今日も大切に扱いましょう。",
    category: "愛"
  },
  {
    message: "朝の光と一緒に、心も体も目覚めさせて。",
    category: "活力"
  },
  {
    message: "今日も、あなたらしく。無理せず、でも諦めずに。",
    category: "応援"
  },
  {
    message: "呼吸に集中する時間は、自分と向き合う時間。",
    category: "内省"
  },
  {
    message: "小さな習慣が、大きな変化を生む。今日も続けましょう。",
    category: "継続"
  },
  {
    message: "体を動かすことは、心を動かすこと。今日も軽やかに。",
    category: "軽やか"
  },
  {
    message: "朝の静寂の中で、自分の声を聞いてみて。",
    category: "静寂"
  },
  {
    message: "今日も、あなたのペースで。焦らず、でも止まらずに。",
    category: "ペース"
  }
]

daily_messages.each do |message_data|
  DailyMessage.find_or_create_by!(message: message_data[:message]) do |message|
    message.category = message_data[:category]
  end
end

puts "シードデータの作成が完了しました！"

# 応援メッセージデータ
encouragement_messages = [
  # ストレッチ用メッセージ
  {
    message: "素晴らしい！体を動かすことで、今日一日のエネルギーが湧いてきます。あなたの体は感謝しています。",
    category: "stretch"
  },
  {
    message: "ストレッチ完了！体が軽くなって、心も軽やかになりましたね。今日も頑張れます！",
    category: "stretch"
  },
  {
    message: "体を伸ばすことで、新しい可能性が広がります。今日も素敵な一日になりますように。",
    category: "stretch"
  },
  {
    message: "ストレッチで体をほぐすことで、心もほぐれていきます。あなたの努力が実を結びます。",
    category: "stretch"
  },
  {
    message: "朝のストレッチで、一日のスタートを気持ちよく切りましたね。今日も頑張りましょう！",
    category: "stretch"
  },
  
  # 呼吸法用メッセージ
  {
    message: "呼吸を整えることで、心も整います。今日も穏やかな気持ちで過ごせますように。",
    category: "breathing"
  },
  {
    message: "深い呼吸で、新しいエネルギーが体に満ちています。今日も素晴らしい一日になります。",
    category: "breathing"
  },
  {
    message: "呼吸法で心を落ち着かせることができましたね。今日も冷静で優しい心で過ごせます。",
    category: "breathing"
  },
  {
    message: "呼吸を意識することで、今この瞬間を大切にできます。今日も充実した一日になりますように。",
    category: "breathing"
  },
  {
    message: "呼吸法で心身のバランスが整いました。今日も調和のとれた一日になります。",
    category: "breathing"
  },
  
  # 一般用メッセージ
  {
    message: "今日も一日頑張りましょう！小さな積み重ねが、大きな変化を生み出します。",
    category: "general"
  },
  {
    message: "あなたのペースで、無理せず進んでいきましょう。完璧である必要はありません。",
    category: "general"
  },
  {
    message: "今日のあなたは、昨日のあなたより少し成長しています。その積み重ねが素晴らしい未来を作ります。",
    category: "general"
  },
  {
    message: "体と心の声に耳を傾けてください。あなたの体は、あなたの味方です。",
    category: "general"
  },
  {
    message: "今日も素敵な一日になりますように。あなたの笑顔が世界を明るくします。",
    category: "general"
  }
]

encouragement_messages.each do |encouragement_data|
  EncouragementMessage.find_or_create_by!(message: encouragement_data[:message]) do |encouragement|
    encouragement.category = encouragement_data[:category]
  end
end

puts "応援メッセージデータも作成完了しました！"
puts "ストレッチ: #{Stretch.count}件"
puts "呼吸法: #{BreathingExercise.count}件"
puts "メッセージ: #{DailyMessage.count}件"

# 過去の活動データを作成（テスト用）
puts "過去の活動データを作成中..."

# 過去30日分の活動データを作成（グラフ表示用）
puts "過去30日分の活動データを作成中..."

(1..30).each do |days_ago|
  date = Date.current - days_ago.days
  
  # その日のストレッチと呼吸法を決定（日付ベースのランダム）
  srand(date.to_time.to_i)
  stretch = Stretch.all.sample
  
  srand(date.to_time.to_i + 1000)
  breathing = BreathingExercise.all.sample
  
  # 活動を記録（80%の確率で記録、より現実的なデータに）
  if rand < 0.8
    UserActivity.find_or_create_by!(date: date, activity_type: 'stretch', activity_id: stretch.id)
  end
  
  if rand < 0.8
    UserActivity.find_or_create_by!(date: date, activity_type: 'breathing', activity_id: breathing.id)
  end
end

puts "過去の活動データ: #{UserActivity.count}件"
