## Análise de Backpressure 

Os testes de carga foram realizados para avaliar a capacidade do sistema em suportar um volume elevado de requisições simultâneas, crucial para entender a evolução e a robustez do nosso backend. Realizar esses testes oferece várias vantagens importantes. Primeiro, permite medir o **total de requisições por segundo**, que indica a taxa de requisições que o sistema consegue processar eficientemente. Essa métrica é essencial para identificar o ponto de saturação do sistema e determinar sua capacidade máxima.

Além disso, os testes monitoram o **tempo de resposta**, que é o tempo necessário para o sistema responder a uma requisição. Manter baixos tempos de resposta é fundamental para garantir uma boa experiência do usuário, especialmente sob cargas elevadas. Ao analisar os tempos de resposta, podemos identificar gargalos e pontos de melhoria no desempenho do sistema.

A terceira métrica, o **número de usuários simultâneos**, refere-se à quantidade de usuários que o sistema consegue suportar antes de ocorrerem falhas. Esta análise é vital para prever como o sistema se comportará em cenários reais de uso intenso e para identificar limites de capacidade.

A análise de backpressure é outra técnica crítica utilizada em conjunto com os testes de carga. O backpressure ajuda a entender como o sistema reage quando a demanda excede sua capacidade. Ao analisar a pressão de retorno, podemos identificar quando o sistema começa a ficar sobrecarregado e implementar estratégias para mitigar esses efeitos, como o balanceamento de carga, escalonamento automático de recursos e otimizações no código.

Essas análises combinadas permitem que a equipe de desenvolvimento tome decisões informadas sobre ajustes necessários na infraestrutura e no software, garantindo que o sistema seja escalável, resiliente e capaz de fornecer uma experiência de usuário consistente e de alta qualidade mesmo sob altas cargas de tráfego.

![Captura de ecrã 2024-05-28 102809](https://github.com/Inteli-College/2024-1B-T02-EC10-G01/assets/99187952/6c16aeda-c27b-465f-bf4b-f9ee8e787f8b)


### Análise dos Resultados

#### Total de Requisições por Segundo

No gráfico, observamos um aumento constante na taxa de requisições por segundo (RPS) até aproximadamente 10:26:00, momento em que o sistema começa a experimentar falhas. A partir desse ponto, a taxa de requisições começa a oscilar, indicando que o sistema atingiu seu limite de capacidade.

#### Tempo de Resposta

Os tempos de resposta se mantiveram baixos até aproximadamente 10:24:00, quando ocorre um pico significativo, sugerindo que o sistema estava sobrecarregado. Este comportamento é evidente pelo aumento no 95º percentil, indicando que as requisições mais lentas ficaram muito mais demoradas durante o pico de carga.

#### Número de Usuários Simultâneos

O número de usuários simultâneos aumenta gradualmente ao longo do tempo até estabilizar em torno de 1.500 usuários por volta de 10:26:00. A partir deste ponto, observa-se que o número de usuários se estabiliza, provavelmente devido ao sistema atingir seu limite de capacidade e começar a rejeitar novas conexões.

### Descoberta de Limitação de Capacidade

Durante os testes, observou-se que ao atingir cerca de 1.500 usuários simultâneos, o sistema começou a apresentar falhas significativas. Isso levou ao aumento no tempo de resposta e ao início de falhas nas requisições. O comportamento observado indica uma limitação na configuração atual do sistema em relação ao número de conexões simultâneas que pode suportar.

### Medidas e Observações Futuras

Estamos trabalhando para melhorar a capacidade do sistema de manejar um maior número de conexões simultâneas. Embora tenhamos identificado uma limitação, acreditamos que a capacidade atual seja suficiente para suportar a quantidade de pedidos simultâneos esperada em condições normais de uso. No entanto, para mitigar os efeitos dessa limitação, serão implementados ajustes nas configurações do servidor e do banco de dados, além de possíveis otimizações no código. Essas medidas visam aumentar a robustez e a escalabilidade do sistema, garantindo que ele continue a oferecer um desempenho confiável e eficiente mesmo sob cargas mais elevadas.
