-- Título: notas.lua
-- Autor: Renan da Fonte
-- Data de criação: 08/04/2017
-- Data de modificação: 09/04/2017
-- Versão: 0.3
-- Tamanho: 324 linhas

	-- Função principal, que coordena a execução do programa
	-- Pré-condição: o programa foi inicializado
	-- Pós-condição: o programa terminou sua execução
	function main()
		print("Calculadora de media de disciplina")		
		local dadosDisciplina = {}
		leDados(dadosDisciplina)
		local media = calculaMedia(dadosDisciplina)
		imprimeMedia(media)
	end
	
	-- Função que lê do input as informações da disciplina cuja média será calculada
	-- Pré-condição: dadosDisciplina existe e não é nulo (checado na linha 24)
	-- Pós-condição: dados necessários para calcular a média de acordo com o critério apontado estão presentes
	function leDados(dadosDisciplina)
		--Checa se dadosDisciplina é nulo
		assert(dadosDisciplina ~= nil, "A variavel dadosDisciplina esta nula no comeco da funcao leDados")
	
		-- Leitura do critério
		leCriterio(dadosDisciplina)
		
		-- Leitura das notas para o cálculo da média
				
		-- Criterio 10 (possui nota teórica e nota para laboratório)
		if dadosDisciplina["criterio"] == 10 then
			leNotasCriterio10(dadosDisciplina)
			return dadosDisciplina -- o cálculo do critério 10 é efetuado de forma diferente dos demais
		end
		
		leNotas(dadosDisciplina)
		
		return dadosDisciplina
	end
	
	-- Função que lê do input o critério da disciplina cuja média será calculada
	-- Pré-condição: dadosDisciplina existe e não é nulo (checado na linha 46)
	-- Pós-condição: critério é um número de 1 a 10 (caso contrário a função entra em recursão)
	function leCriterio(dadosDisciplina)
		assert(dadosDisciplina ~= nil, "A variavel dadosDisciplina esta nula no comeco da funcao leCriterio")
		print("Informe o criterio da disciplina:")
		dadosDisciplina["criterio"] = io.read("*n")
		
		if (dadosDisciplina["criterio"] < 1) or (dadosDisciplina["criterio"] > 10) then
			print("Criterio invalido")
			leCriterio(dadosDisciplina)
		end
		
		return dadosDisciplina
	end
	
	-- Função que coordena a leitura de notas para disciplinas que possuem uma parte teórica e uma de laboratório
	-- Pré-condição: dadosDisciplina existe e não é nulo (checado na linha 62)
	-- Pós-condição: dadosDisciplina["parteTeorica"] e dadosDisciplina["parteLaboratorio"] existem e não são nulos (checado na linha 71)
	function leNotasCriterio10(dadosDisciplina)	
		assert(dadosDisciplina ~= nil, "A variavel dadosDisciplina esta nula no comeco da funcao leNotasCriterio10")
		
		dadosDisciplina["parteTeorica"] = {criterio = 4}
		dadosDisciplina["parteLaboratorio"] = {criterio = 3}
		
		print("\nSobre a parte teorica da disciplina:")
		leNotas(dadosDisciplina["parteTeorica"])
		print("\nSobre a parte de laboratorio da disciplina:")
		leNotas(dadosDisciplina["parteLaboratorio"])
		assert((dadosDisciplina["parteTeorica"] ~= nil) and (dadosDisciplina["parteLaboratorio"] ~= nil), "Os indices parteTeorica e/ou parteLaboratorio de dadosDisciplina estao nulos ao final de leNotasCriterio10")
		
		return dadosDisciplina
	end
	
	-- Função que lê do input as notas do critério
	-- Pré-condição: dadosDisciplina existe e não é nulo (checado na linha 80)
	-- Pós-condição: as notas necessárias para o cálculo da média em cada critério foram lidas
	function leNotas(dadosDisciplina)
		assert(dadosDisciplina ~= nil, "A variavel dadosDisciplina esta nula no comeco da funcao leNotas")
	
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
	-- Pré-condição: dadosDisciplina não é nulo (checado pela assertiva na linha 114) e todos os campos necessários para o cálculo do critério estarem preenchidos em dadosDisciplina
	-- Pós-condição: média não ser nula (a menos que tenha ocorrido algum erro), conforme checado pela assertiva na linha 144
	function calculaMedia(dadosDisciplina)
		-- Checa se dadosDisciplina é nulo
		assert(dadosDisciplina ~= nil, "A variavel dadosDisciplina esta nula no comeco da funcao calculaMedia")
		local media = nil
		
		-- Caso dos critérios 1, 2 ou 3 (apenas G1 e G2)
		if dadosDisciplina["criterio"] < 4 then
			media = calculaCriteriosSemG3(dadosDisciplina)
		
		-- Caso dos critérios 4 e 5 (G1, G2, G3 e G4)
		elseif (dadosDisciplina["criterio"] == 4) or (dadosDisciplina["criterio"] == 5) then
			media = calculaCriteriosComG3EG4(dadosDisciplina)
		
		-- Caso dos critérios 6, 7 e 8
		elseif (dadosDisciplina["criterio"] == 6) or (dadosDisciplina["criterio"] == 7) or (dadosDisciplina["criterio"] == 8) then
			media = calculaCriteriosSemG4(dadosDisciplina)
		
		-- Caso do critério 9
		elseif dadosDisciplina["criterio"] == 9 then
			media = calculaCriteriosComProjeto(dadosDisciplina)
		
		-- Caso do critério 10
		elseif dadosDisciplina["criterio"] == 10 then
			media = calculaCriteriosComLaboratorio(dadosDisciplina)
			
		-- Critério inválido
		else
			assert(false, "Criterio invalido")
		end
	
		assert(media ~= nil, "A media esta nula no fim da funcao de calcular a media")
		return media
	end

	-- Função que calcula a média de disciplinas que não possuem G3
	-- Pré-condição: dadosDisciplina existe e não é nulo, assim como dadosDisciplina["notaG1"] e dadosDisciplina["notaG2"], conforme checado na assertiva presente na linha 152
	-- Pós-condição: média não é nula, conforme checado na assertiva presente na linha 184
	function calculaCriteriosSemG3(dadosDisciplina)
		assert((dadosDisciplina ~= nil) and (dadosDisciplina["notaG1"] ~= nil) and (dadosDisciplina["notaG2"] ~= nil), "A variavel dadosDisciplina ou seus indices notaG1 e/ou notaG2 estao nulos no comeco da funcao calculaCriteriosSemG3")
	
		-- Caso A e caso B estão definidos nos comentários abaixo
		local pesoG1CasoA = 1
		local pesoG2CasoA = 1
		local pesoG1CasoB = 1
		local pesoG2CasoB = 1
		local media = nil
			
		-- Definição dos pesos em cada critério
		if dadosDisciplina["criterio"] == 1 then
			pesoG1CasoA = 2
			pesoG1CasoA = 3
			pesoG2CasoB = 2
			
		elseif dadosDisciplina["criterio"] == 2 then
			pesoG2CasoA = 2
			pesoG2CasoB = 2
				
		elseif dadosDisciplina["criterio"] == 3 then
			pesoG2CasoB = 3
		end
			
		-- Cálculo da média
		if dadosDisciplina["notaG2"] < 3 then
			-- Caso A
			media = (pesoG1CasoB*dadosDisciplina["notaG1"] + pesoG2CasoB*dadosDisciplina["notaG2"])/(pesoG1PiorCaso + pesoG2PiorCaso)
		else
			-- Caso B
			media = (pesoG1CasoA*dadosDisciplina["notaG1"] + pesoG2CasoA*dadosDisciplina["notaG2"])/(pesoG1CasoA + pesoG2CasoA)	
		end
		
		assert(media ~= nil, "A media esta nula ao final da funcao calculaCriteriosSemG3")
		return media
	end
	
	-- Função que calcula a média de disciplinas que possuem G3 e G4
	-- Pré-condição: dadosDisciplina existe e não é nulo, assim como dadosDisciplina["notaG1"], dadosDisciplina["notaG2"], dadosDisciplina["notaG3"] e dadosDisciplina["notaG4"], conforme checado na assertiva presente na linha 192
	-- Pós-condição: média não é nula, conforme checado na assertiva presente na linha 232
	function calculaCriteriosComG3EG4(dadosDisciplina)
		assert((dadosDisciplina ~= nil) and (dadosDisciplina["notaG1"] ~= nil) and (dadosDisciplina["notaG2"] ~= nil) and (dadosDisciplina["notaG3"] ~= nil) and (dadosDisciplina["notaG4"] ~= nil), "A variavel dadosDisciplina ou seus indices notaG1, notaG2, notaG3 e/ou notaG4 estao nulos no comeco da funcao calculaCriteriosComG3EG4")
	
		-- Definição dos pesos em cada critério
		local minMediaParaAprovacaoSemG4 = 5
		local minNotaParaAprovacaoSemG4 = 3
		local media = nil
			
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
		
		assert(media ~= nil, "A media esta nula ao final da funcao calculaCriteriosComG3EG4")
		return media
	end

	-- Função que calcula a média de disciplinas que possuem G3 e G4
	-- Pré-condição: dadosDisciplina existe e não é nulo, assim como dadosDisciplina["notaG1"], dadosDisciplina["notaG2"] e dadosDisciplina["notaG3"], conforme checado na assertiva presente na linha 240
	-- Pós-condição: média não é nula, conforme checado na assertiva presente na linha 289
	function calculaCriteriosSemG4(dadosDisciplina)
		assert((dadosDisciplina ~= nil) and (dadosDisciplina["notaG1"] ~= nil) and (dadosDisciplina["notaG2"] ~= nil) and (dadosDisciplina["notaG3"] ~= nil), "A variavel dadosDisciplina ou seus indices notaG1, notaG2 e/ou notaG2 estao nulos no comeco da funcao calculaCriteriosSemG4")
		
		-- Definição dos pesos em cada critério
		local pesoG1 = 1
		local pesoG2 = 1
		local minMediaParaAprovacaoSemG3 = 5
		local minNotaParaAprovacaoSemG3 = 3
		local media = nil
			
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
		
		assert(media ~= nil, "A media esta nula ao final da funcao calculaCriteriosSemG4")
		return media
	end
	
	-- Função que calcula a média de disciplinas que possuem projeto
	-- Pré-condição: dadosDisciplina existe e não é nulo, assim como dadosDisciplina["notaG1"], dadosDisciplina["notaG2"], dadosDisciplina["notaG3"] e dadosDisciplina["notaProjeto"], conforme checado na assertiva presente na linha 297
	-- Pós-condição: média não é nula, conforme checado na assertiva presente na linha 299
	function calculaCriteriosComProjeto(dadosDisciplina)
		assert((dadosDisciplina ~= nil) and (dadosDisciplina["notaG1"] ~= nil) and (dadosDisciplina["notaG2"] ~= nil) and (dadosDisciplina["notaG3"] ~= nil) and (dadosDisciplina["notaProjeto"] ~= nil), "A variavel dadosDisciplina ou seus indices notaG1, notaG2, notaG3 e/ou notaProjeto estao nulos no comeco da funcao calculaCriteriosComProjeto")
		local media = (dadosDisciplina["notaG1"] + dadosDisciplina["notaG2"] + dadosDisciplina["notaG3"] + dadosDisciplina["notaProjeto"])/4
		assert(media ~= nil, "A media esta nula ao final da funcao calculaCriteriosComProjeto")
		return media
	end
	
	-- Função que calcula a média de disciplinas que possuem laboratório
	-- Pré-condição: dadosDisciplina existe e não é nulo, assim como dadosDisciplina["parteTeorica"] e dadosDisciplina["parteLaboratorio"], conforme checado na assertiva presente na linha 307
	-- Pós-condição: média não é nula, conforme checado na assertiva presente na linha 312
	function calculaCriteriosComLaboratorio(dadosDisciplina)
		assert((dadosDisciplina ~= nil) and (dadosDisciplina["parteTeorica"] ~= nil) and (dadosDisciplina["parteLaboratorio"] ~= nil), "A variavel dadosDisciplina ou seus indices parteTeorica e/ou parteLaboratorio estao nulos no comeco da funcao calculaCriteriosComLaboratorio")
		local mediaTeorica = calculaMedia(dadosDisciplina["parteTeorica"])
		local mediaLaboratorio = calculaMedia(dadosDisciplina["parteLaboratorio"])
			
		local media = (3*mediaTeorica + mediaLaboratorio)/4
		assert(media ~= nil, "A media esta nula ao final da funcao calculaCriteriosComLaboratorio")
		return media
	end
	
	-- Função que imprime na tela a média calculada
	-- Pré-condição: a média não ser nula (checada pela assertiva na linha 320)
	-- Pós-condição: não há
	function imprimeMedia(media)
		assert(media ~= nil, "A media esta nula no comeco da funcao de imprimir a media na tela")
		print("A media nesta disciplina foi " .. media)
	end

main()