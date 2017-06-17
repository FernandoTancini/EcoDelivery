local pista = {}

function pista.carregarPista(numeroFase)
    local pista = {}
    if numeroFase == 1 then
      
      -- inserir o objeto que representa o chao na array que armazena todos objetos da pista
      -- essa array pista será lida pelo método ourPhysics.updatePista() para a construcao da mesma pelo love.physics
      table.insert(pista, criarObstaculoDeLinha(0,450,500,450))
      
      --(3)
      table.insert(pista, criarObstaculoDeLinha(500,450,700,370))
      table.insert(pista, criarObstaculoDeLinha(700,370,700,450))
      
      --chao
      table.insert(pista, criarObstaculoDeLinha(700,450,1300,450))
      
      --(1)+(1)+(1)+(1)
      --(1.1)
      table.insert(pista, criarObstaculoDeLinha(1300,450,1300,415))
      table.insert(pista, criarObstaculoDeLinha(1300,415,1380,415))
      table.insert(pista, criarObstaculoDeLinha(1380,415,1380,450))
      --chao
      table.insert(pista, criarObstaculoDeLinha(1380,450,1450,450))
      --(1.2)
      table.insert(pista, criarObstaculoDeLinha(1450,450,1450,415))
      table.insert(pista, criarObstaculoDeLinha(1450,415,1530,415))
      table.insert(pista, criarObstaculoDeLinha(1530,415,1530,450))
      --chao
      table.insert(pista, criarObstaculoDeLinha(1530,450,1600,450))
      --(1.3)
      table.insert(pista, criarObstaculoDeLinha(1600,450,1600,415))
      table.insert(pista, criarObstaculoDeLinha(1600,415,1680,415))
      table.insert(pista, criarObstaculoDeLinha(1680,415,1680,450))
      --chao
      table.insert(pista, criarObstaculoDeLinha(1680,450,1750,450))
      --(1.4)
      table.insert(pista, criarObstaculoDeLinha(1750,450,1750,415))
      table.insert(pista, criarObstaculoDeLinha(1750,415,1830,415))
      table.insert(pista, criarObstaculoDeLinha(1830,415,1830,450))
      
      --chao
      table.insert(pista, criarObstaculoDeLinha(1830,450,2250,450))
      
      --(5)
      table.insert(pista, criarObstaculoDeLinha(2250,450,2550, 300))
      table.insert(pista, criarObstaculoDeLinha(2550,300,2550, 520))
      table.insert(pista, criarObstaculoDeLinha(2550,520,2900, 520))
      table.insert(pista, criarObstaculoDeLinha(2900,520,2900, 450))
      
      --chao
      table.insert(pista, criarObstaculoDeLinha(2900,450,3400, 450))
      
      -- (2)+(8)
      --(2.1)
      table.insert(pista, criarObstaculoDeLinha(3400,450,3400,420))
      table.insert(pista, criarObstaculoDeLinha(3400,420,3480,420))
      table.insert(pista, criarObstaculoDeLinha(3480,420,3480,450))
      --chao
      table.insert(pista, criarObstaculoDeLinha(3480,450,3550,450))
      --(2.2)
      table.insert(pista, criarObstaculoDeLinha(3550,450,3550,400))
      table.insert(pista, criarObstaculoDeLinha(3550,400,3630,400))
      table.insert(pista, criarObstaculoDeLinha(3630,400,3630,450))
      --chao
      table.insert(pista, criarObstaculoDeLinha(3630,450,3700,450))
      --(2.3)
      table.insert(pista, criarObstaculoDeLinha(3700,450,3700,380))
      table.insert(pista, criarObstaculoDeLinha(3700,380,3780,380))
      table.insert(pista, criarObstaculoDeLinha(3780,380,3780,450))
      --chao
      table.insert(pista, criarObstaculoDeLinha(3780,450,3850,450))
      --(2.4)
      table.insert(pista, criarObstaculoDeLinha(3850,450,3850,360))
      table.insert(pista, criarObstaculoDeLinha(3850,360,3930,360))
      table.insert(pista, criarObstaculoDeLinha(3930,360,3930,520))
      --(8)
      table.insert(pista, criarObstaculoDeLinha(3930,520,4100,520))
      table.insert(pista, criarObstaculoDeLinha(4100,520,4100,450))
      
      --chao
      table.insert(pista, criarObstaculoDeLinha(4100,450,4700,450))
      
      -- (3)+(1)+(1)
      --(3)
      table.insert(pista, criarObstaculoDeLinha(4700,450, 5000,350))
      table.insert(pista, criarObstaculoDeLinha(5000,350, 5000,450))
      table.insert(pista, criarObstaculoDeLinha(5000,450, 5150,450))
      table.insert(pista, criarObstaculoDeLinha(5000,450, 5150,450))
      --(1.1)
      table.insert(pista, criarObstaculoDeLinha(5150,450,5150,370))
      table.insert(pista, criarObstaculoDeLinha(5150,370,5230,370))
      table.insert(pista, criarObstaculoDeLinha(5230,370,5230,450))
      table.insert(pista, criarObstaculoDeLinha(5230,450,5300,450))
      --(1.2)
      table.insert(pista, criarObstaculoDeLinha(5300,450,5300,400))
      table.insert(pista, criarObstaculoDeLinha(5300,400,5380,400))
      table.insert(pista, criarObstaculoDeLinha(5380,400,5380,450))
      
      --chao
      table.insert(pista, criarObstaculoDeLinha(5380,450,6000,450))
      
      --(5)
      table.insert(pista, criarObstaculoDeLinha(6000,450,6200,300))
      table.insert(pista, criarObstaculoDeLinha(6200,300,6200,520))
      table.insert(pista, criarObstaculoDeLinha(6200,520,6450,520))
      table.insert(pista, criarObstaculoDeLinha(6450,520,6450,300))
      table.insert(pista, criarObstaculoDeLinha(6450,300,6650,450))
      
      --chao
      table.insert(pista, criarObstaculoDeLinha(6650,450,8000,450))
      
    end
    return pista
end

function criarObstaculoDeLinha(x1,y1,x2,y2)
  if raio == nil then raio = 2 end
  local linha = {}
  local altura = y2 - y1
  local largura = x2 - x1
  
  local comprimento = math.sqrt(largura*largura + altura*altura)
  local angulacao = math.asin(altura/comprimento)
  
  local xDoCentro = x1 + (x2 - x1) / 2
  local yDoCentro = y1 + (y2 - y1) / 2
  
  obstaculoDeLinha = {}
  obstaculoDeLinha.xInicial = x1
  obstaculoDeLinha.xFinal = x2
  obstaculoDeLinha.yInicial = y1
  obstaculoDeLinha.yFinal = y2
  obstaculoDeLinha.xDoCentro = xDoCentro
  obstaculoDeLinha.yDoCentro = yDoCentro
  obstaculoDeLinha.comprimento = comprimento
  obstaculoDeLinha.angulacao = angulacao
  obstaculoDeLinha.shouldAppear = false
  obstaculoDeLinha.isTocandoRodaEsquerdaDoPersonagem = false
  obstaculoDeLinha.isTocandoRodaDireitaDoPersonagem = false
  obstaculoDeLinha.obstaculo = {}
  return obstaculoDeLinha
end

function pista.getCasaImageAndPosition(numeroFase)
  local image
    local position
  if (numeroFase == 1) then
    image = love.graphics.newImage ("imagens/casa1.png")
    position =  {7750, 180}
  end
  
  return image, position
end


return pista