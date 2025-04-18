
package mage.cards.q;

import java.util.UUID;
import mage.MageInt;
import mage.abilities.Ability;
import mage.abilities.common.SimpleActivatedAbility;
import mage.abilities.common.SimpleStaticAbility;
import mage.abilities.costs.common.TapSourceCost;
import mage.abilities.effects.common.DamageTargetEffect;
import mage.abilities.effects.common.continuous.GainAbilityAllEffect;
import mage.cards.CardImpl;
import mage.cards.CardSetInfo;
import mage.constants.CardType;
import mage.constants.Duration;
import mage.constants.SubType;
import mage.constants.Zone;
import mage.filter.FilterPermanent;
import mage.target.common.TargetAttackingOrBlockingCreature;

/**
 *
 * @author HanClinto
 *
 * A relatively straightforward merge between GemhideSliver.java and
 * CrossbowInfantry.java
 */
public final class QuilledSliver extends CardImpl {

    private static final FilterPermanent filter = new FilterPermanent(SubType.SLIVER, "All Slivers");

    public QuilledSliver(UUID ownerId, CardSetInfo setInfo) {
        super(ownerId,setInfo,new CardType[]{CardType.CREATURE},"{1}{W}");
        this.subtype.add(SubType.SLIVER);

        this.power = new MageInt(1);
        this.toughness = new MageInt(1);

        // All Slivers have "{tap}: This permanent deals 1 damage to target attacking or blocking creature."
        Ability ability = new SimpleActivatedAbility(new DamageTargetEffect(1), new TapSourceCost());
        ability.addTarget(new TargetAttackingOrBlockingCreature());
        this.addAbility(new SimpleStaticAbility(
                new GainAbilityAllEffect(ability,
                        Duration.WhileOnBattlefield, filter,
                        "All Slivers have \"{T}: This permanent deals 1 damage to target attacking or blocking creature.\"")));
    }

    private QuilledSliver(final QuilledSliver card) {
        super(card);
    }

    @Override
    public QuilledSliver copy() {
        return new QuilledSliver(this);
    }
}
