# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Iniciando seed do banco de dados..."

# Limpar dados existentes (apenas em desenvolvimento)
if Rails.env.development? && ENV['CLEAR_SEEDS_ON_DEV'] == 'true'
  puts "🗑️  Limpando dados existentes..."
  Contact.destroy_all
  Sermon.destroy_all
  Post.destroy_all
  SiteConfig::Service.destroy_all
  SiteConfig::Verse.destroy_all
  SiteConfig::Slide.destroy_all
  SiteConfig.destroy_all
  AdminUser.destroy_all
end

# ============================================
# ADMIN USER
# ============================================
puts "👤 Criando usuário administrador..."
admin = AdminUser.create(
  email: 'admin@ipmps-site.com',
  password: 'ipmps-admin-password',
  password_confirmation: 'ipmps-admin-password'
)
puts "   ✅ Admin criado: #{admin.email}"

# ============================================
# SITE CONFIG
# ============================================
puts "⚙️  Criando configuração do site..."
site_config = SiteConfig.create!(
  active: true,
  last_updated_by: admin,
  site_data: {
    title: "Igreja Presbiteriana Marinas Praia Sul",
    description: "Uma comunidade de fé comprometida com o ensino da Palavra de Deus e o serviço ao próximo.",
    intro_title: "Vivendo na Maravilhosa Graça de Deus",
    intro_subtitle: "Uma comunidade de fé comprometida com o ensino da Palavra de Deus e o serviço ao próximo.",
    contact_email: "contato@ipmarinas.com.br",
    contact_phone: "(84) 99999-9999",
    address: "R. Aimorés, 5034 - Neópolis, Natal - RN, 59084-020",
    address_link: "https://maps.app.goo.gl/kyoQyHLwYME5Vm8j7",
    worship_schedule: "Domingos às 10h e 19h",
    facebook: "https://www.facebook.com/ipmarinas/?locale=pt_BR",
    instagram: "https://www.instagram.com/ipmarinas",
    youtube: "https://www.youtube.com/channel/UCXKvuegiiTTogdgThSH_cFA",
    mission: "Glorificar a Deus através da adoração, do ensino da Palavra e do serviço cristão.",
    vision: "Ser uma igreja que transforma vidas através do evangelho de Jesus Cristo."
  }
)
puts "   ✅ Configuração do site criada"

# ============================================
# SLIDES DO CARROSSEL
# ============================================
puts "🖼️  Criando slides do carrossel..."
slides_data = [
  {
    title: "Acesse aqui nosso último culto",
    subtitle: "Culto Vespertino - AO VIVO | Rev. David Sousa | 18/01/2026 | 18H | Ipmarinas",
    content: '<a class="btn btn-primary btn-demo popup-youtube" href="https://www.youtube.com/watch?v=ke2soxicl-g"> <i class="icon-play4"></i> Assista Aqui</a> <a target="_blank" rel="noopener" href="https://www.youtube.com/@ipmarinas" class="btn btn-primary btn-learn">Se Inscreva Aqui! <i class="icon-arrow-right3"></i></a>',
    image: "img_bg_1.jpg"
  },
  {
    title: "Ouça nosso podcast",
    subtitle: "MULHERES NO PÚLPITO: Chamado Bíblico ou Influência Cultural?",
    content: '<a class="btn btn-primary btn-demo popup-youtube" href="https://www.youtube.com/watch?v=PIegFtEyf2Q"> <i class="icon-play4"></i> Assista Aqui</a> <a target="_blank" rel="noopener" href="https://www.youtube.com/@ipmarinas" class="btn btn-primary btn-learn">Se Inscreva Aqui! <i class="icon-arrow-right3"></i></a>',
    image: "img_bg_2.jpg"
  },
  {
    title: "Escola Bíblica Dominical",
    subtitle: "Estudo da Palavra de Deus",
    content: "Todas as idades - Domingos às 9h",
    image: "img_bg_3.jpg"
  },
  {
    title: "Grupos de Estudo",
    subtitle: "Durante a semana",
    content: "Encontros nas casas para comunhão e aprendizado",
    image: "img_bg_1.jpg"
  },
  {
    title: "Ministério Infantil",
    subtitle: "Cuidando das crianças",
    content: "Atividades e ensino bíblico para os pequenos",
    image: "img_bg_2.jpg"
  }
]

slides_data.each do |slide_data|
  slide = SiteConfig::Slide.create!(
    site_config: site_config,
    title: slide_data[:title],
    subtitle: slide_data[:subtitle],
    content: slide_data[:content]
  )

  if slide_data[:image]
    image_path = Rails.root.join('app', 'assets', 'images', slide_data[:image])
    if File.exist?(image_path)
      slide.image.attach(io: File.open(image_path), filename: slide_data[:image])
    end
  end
end
puts "   ✅ #{slides_data.count} slides criados"

# ============================================
# VERSÍCULOS BÍBLICOS
# ============================================
puts "📖 Criando versículos bíblicos..."
verses_data = [
  {
    content: "Porque Deus amou o mundo de tal maneira que deu o seu Filho unigênito, para que todo aquele que nele crê não pereça, mas tenha a vida eterna.",
    reference: "João 3:16"
  },
  {
    content: "Porque pela graça sois salvos, por meio da fé; e isto não vem de vós, é dom de Deus.",
    reference: "Efésios 2:8"
  },
  {
    content: "Posso todas as coisas em Cristo que me fortalece.",
    reference: "Filipenses 4:13"
  },
  {
    content: "O Senhor é o meu pastor; nada me faltará.",
    reference: "Salmos 23:1"
  },
  {
    content: "Entrai por suas portas com ação de graças e nos seus átrios com louvor; louvai-o e bendizei o seu nome.",
    reference: "Salmos 100:4"
  },
  {
    content: "Disse-lhe Jesus: Eu sou o caminho, e a verdade, e a vida. Ninguém vem ao Pai senão por mim.",
    reference: "João 14:6"
  },
  {
    content: "Disse Jesus: Vinde a mim, todos os que estais cansados e oprimidos, e eu vos aliviarei.",
    reference: "Mateus 11:28"
  },
  {
    content: "Não temas, porque eu sou contigo; não te assombres, porque eu sou o teu Deus; eu te fortaleço, e te ajudo, e te sustento com a destra da minha justiça.",
    reference: "Isaías 41:10"
  },
  {
    content: "Confie no Senhor de todo o seu coração e não se apoie em seu próprio entendimento.",
    reference: "Provérbios 3:5"
  },
  {
    content: "O Senhor é a minha luz e a minha salvação; a quem temerei? O Senhor é a força da minha vida; de quem me recearei?",
    reference: "Salmos 27:1"
  },
  {
    content: "E sabemos que todas as coisas contribuem juntamente para o bem daqueles que amam a Deus, daqueles que são chamados por seu decreto.",
    reference: "Romanos 8:28"
  },
  {
    content: "Mas os que esperam no Senhor renovarão as suas forças; subirão com asas como águias; correrão, e não se cansarão; caminharão, e não se fatigarão.",
    reference: "Isaías 40:31"
  },
  {
    content: "Lançando sobre ele toda a vossa ansiedade, porque ele tem cuidado de vós.",
    reference: "1 Pedro 5:7"
  },
  {
    content: "Se confessarmos os nossos pecados, ele é fiel e justo para nos perdoar os pecados e nos purificar de toda injustiça.",
    reference: "1 João 1:9"
  },
  {
    content: "Buscai primeiro o reino de Deus, e a sua justiça, e todas estas coisas vos serão acrescentadas.",
    reference: "Mateus 6:33"
  }
]

verses_data.each do |verse_data|
  SiteConfig::Verse.create!(
    site_config: site_config,
    content: verse_data[:content],
    reference: verse_data[:reference]
  )
end
puts "   ✅ #{verses_data.count} versículos criados"

# ============================================
# SERVIÇOS/REUNIÕES
# ============================================
puts "⛪ Criando serviços e reuniões..."
services_data = [
  {
    title: "Culto de Celebração",
    description: "Culto principal com louvor, pregação da Palavra e Santa Ceia (primeiro domingo do mês).",
    schedule: "Domingos às 10h e 19h",
    image: "img-1.jpg"
  },
  {
    title: "Escola Bíblica Dominical",
    description: "Estudos bíblicos para todas as idades, com classes divididas por faixa etária.",
    schedule: "Domingos às 9h",
    image: "img-2.jpg"
  },
  {
    title: "Culto de Oração",
    description: "Momento dedicado à intercessão, súplicas e gratidão a Deus pela igreja e nação.",
    schedule: "Quartas-feiras às 19h30",
    image: "img-3.jpg"
  },
  {
    title: "Reunião de Jovens",
    description: "Encontro semanal com louvor, estudo bíblico e comunhão para jovens de 15 a 25 anos.",
    schedule: "Sextas-feiras às 19h30",
    image: "img-4.jpg"
  },
  {
    title: "Ministério Infantil",
    description: "Atividades, ensino bíblico e recreação para crianças durante os cultos.",
    schedule: "Domingos às 10h e 19h",
    image: "img-1.jpg"
  },
  {
    title: "Grupo de Casais",
    description: "Encontros mensais para edificação de casamentos cristãos com estudos e comunhão.",
    schedule: "Última sexta do mês às 20h",
    image: "img-2.jpg"
  }
]

services_data.each do |service_data|
  service = SiteConfig::Service.create!(
    site_config: site_config,
    title: service_data[:title],
    description: service_data[:description],
    schedule: service_data[:schedule]
  )

  if service_data[:image]
    image_path = Rails.root.join('app', 'assets', 'images', service_data[:image])
    if File.exist?(image_path)
      service.image.attach(io: File.open(image_path), filename: service_data[:image])
    end
  end
end
puts "   ✅ #{services_data.count} serviços/reuniões criados"

# ============================================
# POSTS - NOTÍCIAS
# ============================================
puts "📰 Criando posts de notícias..."
news_posts = [
  {
    title: "Culto de Ação de Graças 2024",
    description: "Celebramos juntos as bênçãos recebidas durante o ano com um culto especial de gratidão.",
    content: "<h2>Culto de Ação de Graças 2024</h2><p>Foi realizado no último domingo um culto especial de Ação de Graças, onde toda a igreja se reuniu para agradecer as bênçãos de Deus durante este ano. O pastor João Silva pregou sobre o Salmo 100, relembrando que devemos entrar nas portas de Deus com ações de graças.</p><p>A celebração contou com testemunhos emocionantes de membros da igreja, louvor especial do coral e uma ceia comunitária após o culto.</p><h3>Testemunhos Marcantes</h3><p>Maria Silva compartilhou sobre como Deus a sustentou durante um período de doença. José Santos falou sobre as providências financeiras que recebeu. Ana Paula testemunhou sobre a restauração familiar.</p><p>Foi um momento de edificação e fortalecimento da fé de todos os presentes.</p>",
    publication_date: 2.days.ago
  },
  {
    title: "Nova Turma da Escola Bíblica Dominical",
    description: "Abertas as inscrições para a nova turma da EBD focada em estudos do Novo Testamento.",
    content: "<h2>Nova Turma da Escola Bíblica Dominical</h2><p>A Igreja tem a alegria de anunciar a abertura de uma nova turma da Escola Bíblica Dominical, com foco especial nos estudos do Novo Testamento.</p><h3>Detalhes do Curso</h3><ul><li>Início: Próximo domingo</li><li>Horário: 9h às 9h45</li><li>Duração: 6 meses</li><li>Professor: Rev. Carlos Mendes</li></ul><p>O curso abordará os quatro evangelhos, o livro de Atos, as epístolas paulinas e os livros gerais. Será uma oportunidade única de aprofundamento na Palavra de Deus.</p><h3>Como se Inscrever</h3><p>As inscrições podem ser feitas diretamente na secretaria da igreja ou pelo telefone (11) 4728-1234.</p>",
    publication_date: 5.days.ago
  },
  {
    title: "Campanha de Arrecadação de Alimentos",
    description: "Igreja promove campanha solidária para ajudar famílias carentes da comunidade.",
    content: "<h2>Campanha de Arrecadação de Alimentos</h2><p>Durante todo o mês de dezembro, nossa igreja estará promovendo uma campanha de arrecadação de alimentos não perecíveis para distribuição às famílias carentes da região.</p><h3>Itens Mais Necessários</h3><ul><li>Arroz e feijão</li><li>Óleo de cozinha</li><li>Macarrão</li><li>Açúcar e café</li><li>Leite em pó</li><li>Enlatados</li></ul><p>As doações podem ser entregues na secretaria da igreja de segunda a sexta, das 9h às 17h, ou aos domingos antes e depois dos cultos.</p><h3>Meta da Campanha</h3><p>Nossa meta é arrecadar alimentos suficientes para montar 100 cestas básicas completas que serão distribuídas antes do Natal.</p>",
    publication_date: 1.week.ago
  },
  {
    title: "Retiro Espiritual de Carnaval 2025",
    description: "Já estão abertas as inscrições para o retiro espiritual que acontecerá no período de carnaval.",
    content: "<h2>Retiro Espiritual de Carnaval 2025</h2><p>Está com inscrições abertas o tradicional Retiro Espiritual de Carnaval, que acontecerá entre os dias 28 de fevereiro e 3 de março de 2025.</p><h3>Programação</h3><ul><li>Estudos bíblicos diários</li><li>Momentos de louvor e adoração</li><li>Atividades recreativas</li><li>Tempo para descanso e comunhão</li></ul><h3>Local e Investimento</h3><p>O retiro será realizado no Sítio Vale da Benção, em Salesópolis-SP. O investimento é de R$ 350,00 por pessoa (inclui hospedagem e alimentação completa).</p><p>Crianças de 0 a 5 anos: gratuito<br>Crianças de 6 a 12 anos: R$ 180,00</p><h3>Inscrições</h3><p>As vagas são limitadas. Faça sua inscrição com a tesoureira da igreja até dia 15 de janeiro.</p>",
    publication_date: 10.days.ago
  },
  {
    title: "Inauguração da Biblioteca da Igreja",
    description: "Espaço de leitura e estudos foi inaugurado com acervo de mais de 500 livros.",
    content: "<h2>Inauguração da Biblioteca da Igreja</h2><p>Foi inaugurada oficialmente neste domingo a Biblioteca da IPMPS, um sonho antigo da congregação que finalmente se tornou realidade.</p><h3>Acervo Disponível</h3><p>A biblioteca conta com mais de 500 títulos, incluindo:</p><ul><li>Comentários bíblicos</li><li>Teologia sistemática</li><li>História da igreja</li><li>Livros devocionais</li><li>Literatura cristã infantil</li><li>Biografias de grandes servos de Deus</li></ul><h3>Horário de Funcionamento</h3><p>Terças e quintas: 14h às 18h<br>Sábados: 9h às 12h<br>Domingos: após os cultos</p><h3>Como Utilizar</h3><p>Para fazer empréstimos, basta fazer um cadastro simples com a bibliotecária. Cada membro pode emprestar até 3 livros por vez, com prazo de 15 dias.</p>",
    publication_date: 2.weeks.ago
  },
  {
    title: "Conferência Missionária 2024",
    description: "Igreja recebeu missionários de diferentes países para compartilhar experiências e desafios.",
    content: "<h2>Conferência Missionária 2024</h2><p>Durante três dias, nossa igreja foi abençoada com a presença de missionários brasileiros que servem em diferentes partes do mundo, compartilhando suas experiências e os desafios do campo missionário.</p><h3>Missionários Presentes</h3><ul><li>Rev. Paulo e Marta - Moçambique (África)</li><li>Samuel e Débora - Camboja (Ásia)</li><li>Lucas - Portugal (Europa)</li><li>Família Miranda - Bolívia (América do Sul)</li></ul><h3>Temas Abordados</h3><p>As palestras focaram em:</p><ul><li>O chamado missionário</li><li>Desafios culturais e linguísticos</li><li>Plantação de igrejas</li><li>Sustento e parceria missionária</li><li>Cuidado com os filhos de missionários</li></ul><h3>Compromissos Assumidos</h3><p>Ao final da conferência, a igreja assumiu o compromisso de apoiar financeiramente dois novos campos missionários e enviar equipes de curto prazo para auxiliar no trabalho.</p>",
    publication_date: 3.weeks.ago
  },
  {
    title: "Início das Atividades do Ministério de Jovens",
    description: "Novo grupo de jovens se reúne semanalmente para estudo bíblico e comunhão.",
    content: "<h2>Início das Atividades do Ministério de Jovens</h2><p>Com grande alegria anunciamos o início oficial das atividades do Ministério de Jovens da IPMPS, voltado para jovens de 15 a 25 anos.</p><h3>Encontros Semanais</h3><p>O grupo se reunirá todas as sextas-feiras, às 19h30, na sala de jovens da igreja. A programação incluirá:</p><ul><li>Estudo bíblico contextualizado</li><li>Louvor e adoração</li><li>Discussões sobre temas atuais</li><li>Momento de oração</li><li>Confraternização</li></ul><h3>Liderança</h3><p>O ministério será coordenado pelo diácono Rafael Costa e pela presbítera Ana Júlia, ambos com experiência em trabalho com jovens.</p><h3>Atividades Planejadas</h3><p>Já estão no calendário: acampamento de jovens, retiro espiritual, ações sociais, evangelismo nas ruas e muito mais.</p><p>Todos os jovens estão convidados! Traga seus amigos!</p>",
    publication_date: 1.month.ago
  }
]

available_images = [ "img-1.jpg", "img-2.jpg", "img-3.jpg", "img-4.jpg" ]

news_posts.each_with_index do |post_data, index|
  post = Post.create!(
    category: 'news',
    title: post_data[:title],
    description: post_data[:description],
    content: post_data[:content],
    publication_date: post_data[:publication_date]
  )

  # Anexar thumbnail usando as imagens disponíveis de forma rotativa
  image_filename = available_images[index % available_images.length]
  image_path = Rails.root.join('app', 'assets', 'images', image_filename)
  if File.exist?(image_path)
    post.thumbnail.attach(io: File.open(image_path), filename: image_filename)
  end
end
puts "   ✅ #{news_posts.count} notícias criadas"

# ============================================
# POSTS - EVENTOS
# ============================================
puts "📅 Criando posts de eventos..."
events_posts = [
  {
    title: "Culto de Ano Novo 2025",
    description: "Celebração especial de passagem de ano com vigília e ceia.",
    content: "<h2>Culto de Ano Novo 2025</h2><p>Você está convidado para o Culto de Ano Novo, uma celebração especial para darmos adeus a 2024 e recebermos 2025 na presença do Senhor.</p><h3>Programação</h3><ul><li>21h - Início do culto com louvor</li><li>22h - Mensagem da Palavra</li><li>23h - Testemunhos e gratidão</li><li>23h45 - Contagem regressiva</li><li>00h - Oração de consagração do novo ano</li><li>00h30 - Ceia comunitária</li></ul><h3>Informações Importantes</h3><p>Local: Templo da IPMPS<br>Data: 31/12/2024<br>Horário: 21h<br>Entrada: Gratuita</p><p>Pedimos que cada família traga um prato para compartilhar na ceia comunitária após a meia-noite.</p>",
    publication_date: 15.days.from_now
  },
  {
    title: "Curso de Discipulado para Novos Convertidos",
    description: "Início de nova turma do curso básico de discipulado cristão.",
    content: "<h2>Curso de Discipulado para Novos Convertidos</h2><p>Está com inscrições abertas a nova turma do Curso de Discipulado para Novos Convertidos, essencial para quem deseja crescer na fé cristã.</p><h3>Conteúdo do Curso</h3><ul><li>Módulo 1: Fundamentos da Fé Cristã</li><li>Módulo 2: A Bíblia - Palavra de Deus</li><li>Módulo 3: Vida de Oração</li><li>Módulo 4: A Igreja Local</li><li>Módulo 5: Santidade e Crescimento Espiritual</li><li>Módulo 6: Mordomia Cristã</li></ul><h3>Detalhes</h3><p>Início: 15 de janeiro de 2025<br>Duração: 8 semanas<br>Horário: Quartas-feiras, 19h30<br>Professor: Pastor João Silva</p><h3>Inscrições</h3><p>Procure a secretaria da igreja ou ligue: (11) 4728-1234</p>",
    publication_date: 20.days.from_now
  },
  {
    title: "Dia da Família na Igreja",
    description: "Programação especial para toda a família com atividades, brincadeiras e mensagem.",
    content: "<h2>Dia da Família na Igreja</h2><p>Convide toda sua família para um dia especial de celebração, diversão e comunhão!</p><h3>Programação</h3><p><strong>Manhã (9h às 12h)</strong></p><ul><li>Café da manhã comunitário</li><li>Gincana para crianças</li><li>Oficinas para adolescentes</li><li>Bate-papo para adultos: 'Família segundo o coração de Deus'</li></ul><p><strong>Tarde (14h às 18h)</strong></p><ul><li>Culto da família</li><li>Apresentações especiais</li><li>Homenagem aos casais</li><li>Brincadeiras ao ar livre</li><li>Churrasco</li></ul><h3>Informações</h3><p>Data: 25 de janeiro de 2025<br>Local: IPMPS e área externa<br>Traga: Cadeira de praia ou canga<br>Investimento: R$ 25,00 por pessoa (crianças até 10 anos gratuito)</p>",
    publication_date: 1.month.from_now
  },
  {
    title: "Seminário: Criação de Filhos na Era Digital",
    description: "Palestra para pais sobre os desafios de educar filhos no mundo tecnológico atual.",
    content: "<h2>Seminário: Criação de Filhos na Era Digital</h2><p>A igreja promove um seminário especial para pais e educadores sobre os desafios de criar filhos em um mundo cada vez mais digital.</p><h3>Temas Abordados</h3><ul><li>Redes sociais: oportunidades e perigos</li><li>Tempo de tela: quanto é saudável?</li><li>Cyberbullying e como proteger seus filhos</li><li>Conteúdo inapropriado: filtros e conversas</li><li>Formando caráter cristão na era digital</li><li>Alternativas saudáveis ao uso excessivo de tecnologia</li></ul><h3>Palestrante</h3><p>Psicóloga Dra. Fernanda Alves<br>Especialista em família e educação digital</p><h3>Detalhes</h3><p>Data: 8 de fevereiro de 2025<br>Horário: 14h às 17h<br>Local: Salão da igreja<br>Gratuito - Inscrições necessárias</p>",
    publication_date: 6.weeks.from_now
  },
  {
    title: "Café com o Pastor",
    description: "Encontro informal mensal para conversar, tirar dúvidas e fortalecer relacionamentos.",
    content: "<h2>Café com o Pastor</h2><p>O Pastor João Silva convida todos os membros e congregados para um momento especial de comunhão e diálogo.</p><h3>Sobre o Encontro</h3><p>O 'Café com o Pastor' é um encontro informal e acolhedor onde você pode:</p><ul><li>Conhecer melhor o pastor e sua família</li><li>Fazer perguntas sobre fé e vida cristã</li><li>Compartilhar suas experiências</li><li>Fortalecer laços de amizade</li><li>Orar uns pelos outros</li></ul><h3>Como Funciona</h3><p>O encontro acontece mensalmente, sempre no primeiro sábado do mês. Teremos um café da manhã especial seguido de um bate-papo descontraído.</p><h3>Próxima Data</h3><p>Sábado, 7 de dezembro de 2024<br>Horário: 9h às 11h<br>Local: Salão da igreja<br>Não é necessário inscrição</p><p>Venha como você está! Todos são bem-vindos!</p>",
    publication_date: 3.days.from_now
  }
]

events_posts.each_with_index do |post_data, index|
  post = Post.create!(
    category: 'events',
    title: post_data[:title],
    description: post_data[:description],
    content: post_data[:content],
    publication_date: post_data[:publication_date]
  )

  # Anexar thumbnail usando as imagens disponíveis de forma rotativa
  image_filename = available_images[index % available_images.length]
  image_path = Rails.root.join('app', 'assets', 'images', image_filename)
  if File.exist?(image_path)
    post.thumbnail.attach(io: File.open(image_path), filename: image_filename)
  end
end
puts "   ✅ #{events_posts.count} eventos criados"

# ============================================
# SERMÕES
# ============================================
puts "🎤 Criando sermões..."
sermons_data = [
  {
    title: "A Fé que Move Montanhas",
    description: "Estudo sobre Mateus 17:20 e o poder da fé genuína em Deus.",
    link: "https://youtube.com/watch?v=exemplo1"
  },
  {
    title: "O Bom Samaritano nos Dias Atuais",
    description: "Reflexão sobre Lucas 10:25-37 e a prática do amor ao próximo.",
    link: "https://youtube.com/watch?v=exemplo2"
  },
  {
    title: "Vivendo em Santidade",
    description: "Série sobre 1 Pedro 1:15-16 e o chamado para uma vida santa.",
    link: "https://youtube.com/watch?v=exemplo3"
  },
  {
    title: "A Oração do Senhor - Parte 1",
    description: "Estudo detalhado do Pai Nosso em Mateus 6:9-13.",
    link: "https://youtube.com/watch?v=exemplo4"
  },
  {
    title: "A Oração do Senhor - Parte 2",
    description: "Continuação do estudo sobre o Pai Nosso.",
    link: "https://youtube.com/watch?v=exemplo5"
  },
  {
    title: "O Fruto do Espírito",
    description: "Análise de Gálatas 5:22-23 sobre as virtudes cristãs.",
    link: "https://youtube.com/watch?v=exemplo6"
  },
  {
    title: "Perdão: O Caminho da Libertação",
    description: "Mensagem sobre Mateus 6:14-15 e a importância do perdão.",
    link: "https://youtube.com/watch?v=exemplo7"
  },
  {
    title: "Servo Bom e Fiel",
    description: "Estudo sobre Mateus 25:14-30 - Parábola dos Talentos.",
    link: "https://youtube.com/watch?v=exemplo8"
  },
  {
    title: "O Poder da Gratidão",
    description: "Reflexão sobre 1 Tessalonicenses 5:18 e a atitude de gratidão.",
    link: "https://youtube.com/watch?v=exemplo9"
  },
  {
    title: "Família Segundo o Coração de Deus",
    description: "Série sobre princípios bíblicos para a família.",
    link: "https://youtube.com/watch?v=exemplo10"
  },
  {
    title: "A Grande Comissão",
    description: "Estudo sobre Mateus 28:18-20 e o chamado missionário.",
    link: "https://youtube.com/watch?v=exemplo11"
  },
  {
    title: "Paz em Meio à Tempestade",
    description: "Mensagem sobre João 16:33 e a paz que Cristo oferece.",
    link: "https://youtube.com/watch?v=exemplo12"
  },
  {
    title: "A Armadura de Deus",
    description: "Estudo sobre Efésios 6:10-18 e a batalha espiritual.",
    link: "https://youtube.com/watch?v=exemplo13"
  },
  {
    title: "O Sermão do Monte - Bem-Aventuranças",
    description: "Primeira parte da série sobre Mateus 5-7.",
    link: "https://youtube.com/watch?v=exemplo14"
  },
  {
    title: "Crescendo em Graça",
    description: "Reflexão sobre 2 Pedro 3:18 e o crescimento espiritual.",
    link: "https://youtube.com/watch?v=exemplo15"
  },
  {
    title: "O Amor de Deus Revelado",
    description: "Estudo sobre João 3:16 e o amor incondicional de Deus.",
    link: "https://youtube.com/watch?v=exemplo16"
  },
  {
    title: "Discipulado: Seguindo a Jesus",
    description: "Mensagem sobre Lucas 9:23 e o verdadeiro discipulado.",
    link: "https://youtube.com/watch?v=exemplo17"
  },
  {
    title: "A Fidelidade de Deus",
    description: "Estudo sobre Lamentações 3:22-23 e as misericórdias do Senhor.",
    link: "https://youtube.com/watch?v=exemplo18"
  },
  {
    title: "Unidos em Cristo",
    description: "Reflexão sobre Efésios 4:1-6 e a unidade da igreja.",
    link: "https://youtube.com/watch?v=exemplo19"
  },
  {
    title: "A Esperança que não Decepciona",
    description: "Mensagem sobre Romanos 5:1-5 e a esperança cristã.",
    link: "https://youtube.com/watch?v=exemplo20"
  }
]

sermons_data.each do |sermon_data|
  Sermon.create!(
    title: sermon_data[:title],
    description: sermon_data[:description],
    link: sermon_data[:link]
  )
end
puts "   ✅ #{sermons_data.count} sermões criados"

# ============================================
# CONTATOS (mensagens recebidas)
# ============================================
puts "✉️  Criando mensagens de contato..."
contacts_data = [
  {
    name: "Maria Silva",
    email: "maria.silva@email.com",
    phone: "(11) 98765-4321",
    address: "Rua das Palmeiras, 456 - Mogi das Cruzes",
    message: "Olá! Gostaria de saber mais informações sobre os horários dos cultos e se há escola bíblica para crianças. Tenho dois filhos de 6 e 8 anos e estamos procurando uma igreja para congregar. Aguardo retorno. Que Deus abençoe!"
  },
  {
    name: "José Santos",
    email: "jose.santos@email.com",
    phone: "(11) 97654-3210",
    message: "Bom dia! Vi o anúncio sobre o retiro de carnaval e gostaria de me inscrever junto com minha esposa. Como faço para realizar a inscrição e qual a forma de pagamento? Também gostaria de saber se há opção de parcelamento. Obrigado!"
  },
  {
    name: "Ana Paula Costa",
    email: "ana.costa@email.com",
    phone: "(11) 96543-2109",
    address: "Av. Brasil, 789 - Parque Santana",
    message: "Sou nova na região e estou procurando uma igreja presbiteriana para congregar. Visitei o site de vocês e me interessei muito. Gostaria de visitar a igreja no próximo domingo. Vocês têm algum programa de recepção para visitantes? Desde já agradeço a atenção."
  },
  {
    name: "Carlos Mendes",
    email: "carlos.mendes@email.com",
    phone: "(11) 95432-1098",
    message: "Paz do Senhor! Tenho interesse em participar do grupo de jovens da igreja. Tenho 19 anos e recentemente me mudei para Mogi das Cruzes. Poderia me passar mais informações sobre os encontros e atividades? Aguardo contato. Deus abençoe!"
  },
  {
    name: "Fernanda Oliveira",
    email: "fernanda.oliveira@email.com",
    phone: "(11) 94321-0987",
    address: "Rua São João, 321 - Centro",
    message: "Boa tarde! Meu esposo e eu gostaríamos de fazer parte da campanha de arrecadação de alimentos. Como podemos ajudar? Temos disponibilidade para ajudar na organização e distribuição das cestas também. Aguardamos orientações de como podemos servir."
  },
  {
    name: "Roberto Lima",
    email: "roberto.lima@email.com",
    phone: "(11) 93210-9876",
    message: "Tenho interesse em conhecer mais sobre o curso de discipulado para novos convertidos. Recentemente entreguei minha vida a Cristo e quero aprender mais sobre a Palavra de Deus. O curso é gratuito? Preciso levar algum material? Obrigado pela atenção!"
  },
  {
    name: "Juliana Ferreira",
    email: "juliana.ferreira@email.com",
    phone: "(11) 92109-8765",
    address: "Rua das Acácias, 654 - Vila Mogilar",
    message: "Olá! Sou professora de música e vi que a igreja tem um coral. Gostaria de saber se há vagas e como funciona os ensaios. Toco piano e tenho experiência em ministério de louvor. Fico no aguardo de um retorno. Que Deus os abençoe!"
  },
  {
    name: "Pedro Alves",
    email: "pedro.alves@email.com",
    phone: "(11) 91098-7654",
    message: "Paz de Cristo! Estou passando por um momento difícil em minha vida e preciso de oração e aconselhamento. Seria possível agendar uma conversa com o pastor? Agradeço desde já pela compreensão e pelas orações. Que Deus continue abençoando este ministério."
  },
  {
    name: "Mariana Santos",
    email: "mariana.santos@email.com",
    phone: "(11) 90987-6543",
    address: "Rua Santos Dumont, 987 - Jundiapeba",
    message: "Bom dia! Tenho uma filha de 4 anos e gostaria de informações sobre o ministério infantil da igreja. Quais são os horários? Há vagas disponíveis? As professoras são capacitadas? Muito obrigada pela atenção!"
  },
  {
    name: "Lucas Rodrigues",
    email: "lucas.rodrigues@email.com",
    phone: "(11) 99876-5432",
    message: "Olá! Sou estudante de teologia e estou fazendo uma pesquisa sobre igrejas presbiterianas na região. Gostaria de saber se seria possível agendar uma visita para conhecer melhor a história e o trabalho da igreja. Agradeço a compreensão e disponibilidade."
  }
]

contacts_data.each do |contact_data|
  Contact.create!(contact_data)
end
puts "   ✅ #{contacts_data.count} mensagens de contato criadas"

# ============================================
# RESUMO
# ============================================
puts "\n" + "=" * 50
puts "✅ SEED CONCLUÍDO COM SUCESSO!"
puts "=" * 50
puts "📊 Resumo:"
puts "   - AdminUsers: #{AdminUser.count}"
puts "   - SiteConfigs: #{SiteConfig.count}"
puts "   - Slides: #{SiteConfig::Slide.count}"
puts "   - Versículos: #{SiteConfig::Verse.count}"
puts "   - Serviços/Reuniões: #{SiteConfig::Service.count}"
puts "   - Posts (Notícias): #{Post.where(category: 'news').count}"
puts "   - Posts (Eventos): #{Post.where(category: 'events').count}"
puts "   - Sermões: #{Sermon.count}"
puts "   - Contatos: #{Contact.count}"
puts "=" * 50
puts "🎉 Banco de dados populado com sucesso!"
