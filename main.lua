 
-- testiiiiii
 local fase
 
 local estadoAtual = "menu"
 local estadoMenu = "jogar"
 local delayMenu = 0
 
 local alturaMundo = 740 -- *****ATUALMENTE TODAS PISTAS (TODAS FASES) TERAO ESSAS DIMENSOES PARA O MUNDO*****
 local laguraMundo = 8000 -- *****ATUALMENTE TODAS PISTAS (TODAS FASES) TERAO ESSAS DIMENSOES PARA O MUNDO*****
 
 local alturaTela = 600
 local larguraTela = 800
 
 local menuJogarImagem = null
 local menuInsrucoesImagem = null
 local menuSairImagem = null
 
 local instrucoesImagem = null
 
-- LOAD --------------------------------------------------
function love.load()
  fase = require "fase"
  
  menuJogarImagem = love.graphics.newImage("imagens/menu_jogar.png")
  menuInsrucoesImagem = love.graphics.newImage("imagens/menu_instrucoes.png")
  menuSairImagem = love.graphics.newImage("imagens/menu_sair.png")
  
  instrucoesImagem = love.graphics.newImage("imagens/instrucoes.png")
  
  -- inicializar a fase, indicando a largura e altura da pista (apenas isso por enquanto)
  fase.init(laguraMundo, alturaMundo)
  -- realizar o load() da fase
  fase.load(1) -- o 1 se refere ao numero da fase
end

-- update --------------------------------------------------
function love.update(dt)
  
  delayMenu = delayMenu + dt
  
  if (estadoAtual == "jogando") then
    
    -- ver se ja acabou
    if (fase.acabou) then
      
      estadoAtual = "congratulacoes"
      fase.acabou = false
      
    else
      
      --verificar se eh p pausar
    if (love.keyboard.isDown("p")) then
      estadoAtual = "pausado"
    else
      -- realizar o update() da fase
      fase.update(dt)
    end
      
    end
    
  elseif (estadoAtual == "pausado") then
    
    -- verificar se eh pra voltar ao jogo ou sair para o menu
    if (love.keyboard.isDown("b")) then
      estadoAtual = "jogando"
    elseif (love.keyboard.isDown("m")) then
      estadoAtual = "menu"
    elseif (love.keyboard.isDown("r")) then
      fase.reset = true
      estadoAtual = "jogando"
    end
    
  elseif (estadoAtual == "menu") then
    
    if (love.keyboard.isDown("down") and delayMenu > 0.1) then
      delayMenu = 0
      if (estadoMenu == "jogar") then
        estadoMenu = "instrucoes"
      elseif (estadoMenu == "instrucoes") then
        estadoMenu = "sair"
      elseif (estadoMenu == "sair") then
        estadoMenu = "jogar"
      end
      
    elseif (love.keyboard.isDown("up") and delayMenu > 0.1) then
      delayMenu = 0
      if (estadoMenu == "jogar") then
        estadoMenu = "sair"
      elseif (estadoMenu == "instrucoes") then
        estadoMenu = "jogar"
      elseif (estadoMenu == "sair") then
        estadoMenu = "instrucoes"
      end
      
    elseif (love.keyboard.isDown("return")) then
        
      if (estadoMenu == "jogar") then
        estadoAtual = "jogando"
      -- importante fazer isso para reiniciar a fase!
      fase.reset = true
      elseif (estadoMenu == "instrucoes") then
        estadoAtual = "instrucoes"
      elseif (estadoMenu == "sair") then
        love.event.quit( )
      end
      
    end
  elseif (estadoAtual == "instrucoes") then
    if (love.keyboard.isDown("escape")) then
      estadoAtual = "menu"
    end
    
  elseif (estadoAtual == "congratulacoes") then
    if (love.keyboard.isDown("escape")) then
      estadoAtual = "menu"
    end
  end

end
-- update --------------------------------------------------
function love.draw()
  
  if (estadoAtual == "jogando") then
    
    love.graphics.setBackgroundColor(0,0,0)
    
    -- realizar o draw() da fase
    fase.draw()
    
    --fazer aviso da tecla de pausa e reset
    love.graphics.setColor(255,255,255)
    love.graphics.print("Pressione a tecla \"P\" para pausar o jogo.", fase.getXInicialCamera() + (larguraTela/2), fase.getYInicialCamera() + 10)   
  elseif (estadoAtual == "pausado") then
    -- realizar o draw() da fase e a pausa por cima
    -- fase
    fase.draw()
    --pausa
    love.graphics.setColor(0,0,0, 150)
    love.graphics.rectangle("fill", fase.getXInicialCamera(), fase.getYInicialCamera(), larguraTela, alturaTela)
    love.graphics.setColor(255,255,255)
    love.graphics.print("Pressione:\n\"B\" -> para voltar ao jogo\n\"R\" -> para reiniciar o jogo\n\"M\" -> para voltar ao menu", fase.getXInicialCamera() + 100, fase.getYInicialCamera() + (alturaTela/2))
    
  elseif (estadoAtual == "menu") then
    love.graphics.setColor(255,255,255)
    if (estadoMenu == "jogar") then
      love.graphics.draw(menuJogarImagem)
    elseif (estadoMenu == "instrucoes") then
      love.graphics.draw(menuInsrucoesImagem)
    elseif (estadoMenu == "sair") then
      love.graphics.draw(menuSairImagem)
    end
    
  elseif (estadoAtual == "instrucoes") then
        
    love.graphics.draw(instrucoesImagem)
    
    elseif (estadoAtual == "congratulacoes") then
      
      love.graphics.setBackgroundColor(60,60,60)
      
      -- TODO: por a imagem de congratulacoes
      love.graphics.print("UHUUUUUUUUUULLLLLL\nParabéns pra você!!! Uma verdadeira pessoa E C O L Ó G I C A!!!\n\n    Nós, desenvolvedores do EcoDelivery, concebemos todo o universo desse jogo com o intuito de conscientizar\ncada jogador sobre a iportância de mudarmos nosso estilo de vida consumista, materialista, capitalista (pois o\nconsumismo e materialismo são infelizmente intrínsseco ao capitalismo que se conhece :/), antiético, individualista\ne agressivo ao ambiente em que estamos inseridos, a Terra, o mais rápido possível.\n\n    Obrigado por jogar e seja a mudança que você gostaria que acontecesse.\n\n    Obs.: contanto que essa mudança não viole o meio ambiente de uma forma antiética ou que desrespeite\nou seja agressivo com qualquer ser vivo inserido nele, é claro.\n\n    Aperte ESC para voltar ao menu", 50, 200)
    
  end
  
end