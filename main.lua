 
-- testiiiiii
 local fase
 
 local estadoAtual = "menu"
 
 local alturaMundo = 740 -- *****ATUALMENTE TODAS PISTAS (TODAS FASES) TERAO ESSAS DIMENSOES PARA O MUNDO*****
 local laguraMundo = 8000 -- *****ATUALMENTE TODAS PISTAS (TODAS FASES) TERAO ESSAS DIMENSOES PARA O MUNDO*****
 
 local alturaTela = 600
 local larguraTela = 800
 
-- LOAD --------------------------------------------------
function love.load()
  fase = require "fase"
  
  -- inicializar a fase, indicando a largura e altura da pista (apenas isso por enquanto)
  fase.init(laguraMundo, alturaMundo)
  -- realizar o load() da fase
  fase.load(1) -- o 1 se refere ao numero da fase
end

-- update --------------------------------------------------
function love.update(dt)
  
  if (estadoAtual == "jogando") then
    
    --verificar se eh p pausar
    if (love.keyboard.isDown("p")) then
      estadoAtual = "pausado"
    else
      -- realizar o update() da fase
      fase.update(dt)
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
    if (love.keyboard.isDown("c") and love.keyboard.isDown("u")) then
      estadoAtual = "jogando"
      -- importante fazer isso para reiniciar a fase!
      fase.reset = true
    end
  end

end
-- update --------------------------------------------------
function love.draw()
  
  if (estadoAtual == "jogando") then
    -- realizar o draw() da fase
    fase.draw()
    
    --fazer aviso da tecla de pausa e reset
    love.graphics.setColor(255,255,255)
    love.graphics.print("Pressione a tecla \"p\" para pausar o jogo.", fase.getXInicialCamera() + (larguraTela/2), fase.getYInicialCamera() + 10)   
  elseif (estadoAtual == "pausado") then
    -- realizar o draw() da fase e a pausa por cima
    -- fase
    fase.draw()
    --pausa
    love.graphics.setColor(0,0,0, 150)
    love.graphics.rectangle("fill", fase.getXInicialCamera(), fase.getYInicialCamera(), larguraTela, alturaTela)
    love.graphics.setColor(255,255,255)
    love.graphics.print("Pressione a tecla \"b\" para voltar ao jogo,\na tecla \"m\" para sair do jogo e voltar ao menu,\ne a tecla \"r\" para reiniciar o jogo.", fase.getXInicialCamera() + 100, fase.getYInicialCamera() + (alturaTela/2))
    
  elseif (estadoAtual == "menu") then
    love.graphics.setBackgroundColor(0,0,0)
    love.graphics.print("Pressione as teclas \"C\" e \"U\" ao mesmo tempo para comecar uma nova partida na Fase 1.", 100, 280)
    
  end
end