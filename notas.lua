-- Título: notas.lua
-- Autor: Renan da Fonte
-- Data de criação: 08/04/2017
-- Data de modificação: 08/04/2017
-- Versão: 0.1
-- Tamanho: 219 linhas

	-- Função principal, que coordena a execução do programa
	-- Pré-condição: o programa foi inicializado
	-- Pós-condição: o programa terminou sua execução
	function main()
		print("Calculadora de media de disciplina")
		local dadosDisciplina = leDados()
		local media = calculaMedia(dadosDisciplina)
		imprimeMedia(media)
	end
	
	-- Função que cria 'dadosDisciplina' e lê do input as informações da disciplina cuja média será calculada
	-- Pré-condição: não há
	-- Pós-condição: dados necessários para calcular a média de acordo com o critério apontado estão presentes
	function leDados()
		local dadosDisciplina = {}
		
		-- Leitura do critério
		print("Informe o criterio da disciplina:")
		dadosDisciplina["criterio"] = io.read("*n")
		
		-- Leitura das notas para o cálculo da média
				
		-- Criterio 10 (possui nota teórica e nota para laboratório)
		if dadosDisciplina["criterio"] == 10 then
			print("\nSobre a parte teorica da disciplina:")
			dadosDisciplina["parteTeorica"] = leDados()
			print("\nSobre a parte de laboratorio da disciplina:")
			dadosDisciplina["parteLaboratorio"] = leDados()
			return dadosDisciplina -- o cálculo do critério 10 é efetuado de forma diferente dos demais
		end
		
		-- Leitura da G1
		print("Informe a nota da G1:")
		dadosDisciplina["notaG1"] = io.read("*n")
		
		-- Leitura da G2
		print("Informe a nota da G2:")
		dadosDisciplina["notaG2"] = io.read("*n")
		
		-- Leitura da G3 (caso o critério possua G3)
		if dadosDisciplina["criterio"] >= 4 then -- critérios de 4 a 9 possuem G3		
			print("Informe a nota da G3 ou 0 caso nao tenha feito:")
			dadosDisciplina["notaG3"] = io.read("*n")
		end
		
		-- Leitura da G4 (categorias 4 e 5)
		if (dadosDisciplina["criterio"] == 4) or (dadosDisciplina["criterio"] == 5) then
			print("Informe a nota da G4 ou 0 caso nao tenha feito:")
			dadosDisciplina["notaG4"] = io.read("*n")
		end
		
		-- Leitura da nota de projeto (categoria 9 apenas)
		if dadosDisciplina["criterio"] == 9 then
			print("Informe a nota do projeto:")
			dadosDisciplina["notaProjeto"] = io.read("*n")
		end
		
		return dadosDisciplina
	end
	
	-- Função que calcula a média da disciplina
	-- Pré-condição: dadosDisciplina não é nulo (checado pela assertiva na linha 73) e todos os campos necessários para o cálculo do critério estarem preenchidos em dadosDisciplina
	-- Pós-condição: média não ser nula (a menos que tenha ocorrido algum erro), conforme checado pela assertiva na linha 83
	function calculaMedia(dadosDisciplina)
		-- Checa se dadosDisciplina é nulo
		assert(dadosDisciplina ~= nil, "A variavel dadosDisciplina esta nula")
		local media = nil
		
		-- Caso dos critérios 1, 2 ou 3 (apenas G1 e G2)
		if dadosDisciplina["criterio"] < 4 then
			local pesoG1 = 1
			local pesoG2 = 1
			local pesoG1PiorCaso = 1
			local pesoG2PiorCaso = 1
			
			-- Definição dos pesos em cada critério
			if dadosDisciplina["criterio"] == 1 then
				pesoG1 = 2
				pesoG2 = 3
				pesoG2PiorCaso = 2
				
			elseif dadosDisciplina["criterio"] == 2 then
				pesoG2 = 2
				pesoG2PiorCaso = 2
				
			elseif dadosDisciplina["criterio"] == 3 then
				pesoG2PiorCaso = 3
			end
			
			-- Cálculo da média
			if dadosDisciplina["notaG2"] < 3 then
				media = (pesoG1PiorCaso*dadosDisciplina["notaG1"] + pesoG2PiorCaso*dadosDisciplina["notaG2"])/(pesoG1PiorCaso + pesoG2PiorCaso)
			else
				media = (pesoG1*dadosDisciplina["notaG1"] + pesoG2*dadosDisciplina["notaG2"])/(pesoG1 + pesoG2)	
			end
		
		-- Caso dos critérios 4 e 5 (G1, G2, G3 e G4)
		elseif (dadosDisciplina["criterio"] == 4) or (dadosDisciplina["criterio"] == 5) then
			-- Definição dos pesos em cada critério
			local minMediaParaAprovacaoSemG4 = 5
			local minNotaParaAprovacaoSemG4 = 3
			
			if dadosDisciplina["criterio"] == 5 then
				minMediaParaAprovacaoSemG4 = 6
				minNotaParaAprovacaoSemG4 = 5
			end
			
			-- Cálculo da média
			media = (dadosDisciplina["notaG1"] + dadosDisciplina["notaG2"] + dadosDisciplina["notaG3"])/3
			
			-- Checa se é necessário prova final e recalcula a média em caso positivo
			if (media < minMediaParaAprovacaoSemG4) or (dadosDisciplina["notaG1"] < minNotaParaAprovacaoSemG4) or (dadosDisciplina["notaG2"] < minNotaParaAprovacaoSemG4) or (dadosDisciplina["notaG3"] < minNotaParaAprovacaoSemG4) then
				-- Em caso de G4 com nota maior ou igual a 3
				if dadosDisciplina["notaG4"] >= 3 then
					-- Verifica menor nota
					local notaMenor = nil
					if (dadosDisciplina["notaG1"] <= dadosDisciplina["notaG2"]) and (dadosDisciplina["notaG1"] <= dadosDisciplina["notaG3"]) then
						notaMenor = dadosDisciplina["notaG1"]
					elseif (dadosDisciplina["notaG2"] <= dadosDisciplina["notaG1"]) and (dadosDisciplina["notaG2"] <= dadosDisciplina["notaG3"]) then
						notaMenor = dadosDisciplina["notaG2"]
					else
						notaMenor = dadosDisciplina["notaG3"]
					end
					
					-- Média de todas as notas, tirando a menor
					media = (3*media - notaMenor + dadosDisciplina["notaG4"])/3
				
				-- Caso contrário
				else
					-- Média de todas as notas, com G4 com peso 3
					media = (media + dadosDisciplina["notaG4"])/2
					
				end
			end
		
		-- Caso dos critérios 6, 7 e 8
		elseif (dadosDisciplina["criterio"] == 6) or (dadosDisciplina["criterio"] == 7) or (dadosDisciplina["criterio"] == 8) then
			-- Definição dos pesos em cada critério
			local pesoG1 = 1
			local pesoG2 = 1
			local minMediaParaAprovacaoSemG3 = 5
			local minNotaParaAprovacaoSemG3 = 3
			
			if dadosDisciplina["criterio"] == 7 then
				minMediaParaAprovacaoSemG3 = 6
			elseif dadosDisciplina["criterio"] == 8 then
				pesoG1 = 2
				pesoG2 = 3
				minMediaParaAprovacaoSemG3 = 6
			end
			
			-- Cálculo da média
			media = (pesoG1*dadosDisciplina["notaG1"] + pesoG2*dadosDisciplina["notaG2"])/(pesoG1 + pesoG2)
			
			-- Casos que necessitam de G3		
			if (media < minMediaParaAprovacaoSemG3) or (dadosDisciplina["notaG1"] < minNotaParaAprovacaoSemG3) or (dadosDisciplina["notaG2"] < minNotaParaAprovacaoSemG3) then
				
				-- Caso A
				if (media < minMediaParaAprovacaoSemG3) and ((dadosDisciplina["criterio"] == 7) or 
				((dadosDisciplina["notaG1"] < minNotaParaAprovacaoSemG3) or (dadosDisciplina["notaG2"] < minNotaParaAprovacaoSemG3)) and (dadosDisciplina["notaG3"] < minNotaParaAprovacaoSemG3)) then				
					media = (dadosDisciplina["notaG1"] + dadosDisciplina["notaG2"] + 2*dadosDisciplina["notaG3"])/4
				
				-- Caso B
				elseif (dadosDisciplina["criterio"] == 6) then
					-- Verifica menor nota
					local notaMenor = nil
					if (dadosDisciplina["notaG1"] <= dadosDisciplina["notaG2"]) and (dadosDisciplina["notaG1"] <= dadosDisciplina["notaG3"]) then
						notaMenor = dadosDisciplina["notaG1"]
					elseif (dadosDisciplina["notaG2"] <= dadosDisciplina["notaG1"]) and (dadosDisciplina["notaG2"] <= dadosDisciplina["notaG3"]) then
						notaMenor = dadosDisciplina["notaG2"]
					else
						notaMenor = dadosDisciplina["notaG3"]
					end
					
					-- Média das duas maiores notas
					media = (2*media + dadosDisciplina["notaG3"] - notaMenor)/2
				
				-- Caso C -> só deve ocorrer no critério 8
				else
					media = (2*dadosDisciplina["notaG1"] + 3*dadosDisciplina["notaG2"] + 5*dadosDisciplina["notaG3"])/10
				end
			end
		
		-- Caso do critério 9
		elseif dadosDisciplina["criterio"] == 9 then
			media = (dadosDisciplina["notaG1"] + dadosDisciplina["notaG2"] + dadosDisciplina["notaG3"] + dadosDisciplina["notaProjeto"])/4
		
		-- Caso do critério 10
		elseif dadosDisciplina["criterio"] == 10 then
			local mediaTeorica = calculaMedia(dadosDisciplina["parteTeorica"])
			local mediaLaboratorio = calculaMedia(dadosDisciplina["parteLaboratorio"])
			
			media = (3*mediaTeorica + mediaLaboratorio)/4
			
		-- Critério inválido
		else
			assert(false, "Criterio invalido")
		end
	
		assert(media ~= nil, "A media esta nula no fim da funcao de calcular a media")
		return media
	end
	
	-- Função que imprime na tela a média calculada
	-- Pré-condição: a média não ser nula (checada pela assertiva na linha 91)
	-- Pós-condição: não há
	function imprimeMedia(media)
		assert(media ~= nil, "A media esta nula no comeco da funcao de imprimir a media na tela")
		print("A media nesta disciplina foi " .. media)
	end

main()