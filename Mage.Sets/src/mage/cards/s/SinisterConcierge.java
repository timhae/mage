package mage.cards.s;

import mage.MageInt;
import mage.MageObjectReference;
import mage.abilities.Ability;
import mage.abilities.common.DiesSourceTriggeredAbility;
import mage.abilities.costs.Cost;
import mage.abilities.costs.common.ExileSourceWithTimeCountersCost;
import mage.abilities.dynamicvalue.common.StaticValue;
import mage.abilities.effects.Effect;
import mage.abilities.effects.OneShotEffect;
import mage.abilities.effects.common.DoIfCostPaid;
import mage.abilities.effects.common.ExileTargetEffect;
import mage.abilities.effects.common.continuous.GainSuspendEffect;
import mage.abilities.effects.common.counter.AddCountersSourceEffect;
import mage.abilities.effects.common.counter.AddCountersTargetEffect;
import mage.abilities.keyword.SuspendAbility;
import mage.cards.Card;
import mage.cards.CardImpl;
import mage.cards.CardSetInfo;
import mage.constants.CardType;
import mage.constants.Outcome;
import mage.constants.SubType;
import mage.constants.Zone;
import mage.counters.CounterType;
import mage.game.Game;
import mage.game.permanent.Permanent;
import mage.players.Player;
import mage.target.common.TargetCreaturePermanent;

import java.util.UUID;

/**
 * @author Alex-Vasile
 */
public class SinisterConcierge extends CardImpl {

    public SinisterConcierge(UUID ownerId, CardSetInfo setInfo) {
        super(ownerId, setInfo, new CardType[]{CardType.CREATURE}, "{1}{U}");

        this.addSubType(SubType.HUMAN, SubType.WIZARD);
        this.power = new MageInt(2);
        this.toughness = new MageInt(1);

        // When Sinister Concierge dies, you may exile it and put three time counters on it.
        // If you do, exile up to one target creature and put three time counters on it.
        // Each card exiled this way that doesn't have suspend gains suspend.
        // (For each card with suspend, its owner removes a time counter from it at the beginning of their upkeep.
        // When the last is removed, they may cast it without paying its mana cost. Those creature spells have haste.)
	Cost cost = new ExileSourceWithTimeCountersCost(3, false, true, Zone.GRAVEYARD);
	// Paying the cost sends the Concierge to the right exile zone (Suspended cards of…) and gives it suspend.
	cost.setText("exile it and put three time counters on it");
	Ability ability = new DiesSourceTriggeredAbility(
                new DoIfCostPaid(
                        new SinisterConciergeEffect(),
                        cost 
                )
        );
        ability.addTarget(new TargetCreaturePermanent(0, 1));
        this.addAbility(ability);
    }

    private SinisterConcierge(final SinisterConcierge card) {
        super(card);
    }

    @Override
    public SinisterConcierge copy() {
        return new SinisterConcierge(this);
    }
}

class SinisterConciergeEffect extends OneShotEffect {
    public SinisterConciergeEffect() {
        super(Outcome.Removal);
        this.staticText = "exile up to one target creature and put three time counters on it. " +
                "Each card exiled this way that doesn't have suspend gains suspend. " +
                "<i>(For each card with suspend, its owner removes a time counter from it at the beginning of their upkeep. " +
                "When the last is removed, they may cast it without paying its mana cost. Those creature spells have haste.)</i>";
    }

    private SinisterConciergeEffect(final SinisterConciergeEffect effect) {
        super(effect);
    }

    @Override
    public boolean apply(Game game, Ability source) {
        Player controller = game.getPlayer(source.getControllerId());
        Card card = game.getCard(source.getSourceId());
        if (controller == null || card == null) {
            return false;
        }

        Permanent targetCreature = game.getPermanent(this.getTargetPointer().getFirst(game, source));
        if (targetCreature == null){
            return false;
        }

        // Exile, put time counters, and give suspend for target
	Player controllerTarget = game.getPlayer(targetCreature.getControllerId());
        UUID exileId = SuspendAbility.getSuspendExileId(controllerTarget.getId(), game);
      	Effect exileTarget = new ExileTargetEffect(exileId, "Suspended cards of " + controllerTarget.getName());
        exileTarget.setTargetPointer(this.getTargetPointer().copy());
        if (exileTarget.apply(game, source)) {
            Effect addCountersTargetEffect = new AddCountersTargetEffect(CounterType.TIME.createInstance(3));
            addCountersTargetEffect.setTargetPointer(this.getTargetPointer().copy());
            boolean targetCardShouldGetSuspend = addCountersTargetEffect.apply(game, source);

            if (targetCardShouldGetSuspend && !targetCreature.getAbilities(game).containsClass(SuspendAbility.class)) {
                Card targetCard = game.getCard(getTargetPointer().getFirst(game, source));
                if (!targetCard.getAbilities(game).containsClass(SuspendAbility.class)) {
                    game.addEffect(new GainSuspendEffect(new MageObjectReference(targetCard, game)), source);
                }
            }
        }

        return true;
    }

    @Override
    public SinisterConciergeEffect copy() {
        return new SinisterConciergeEffect(this);
    }
}
